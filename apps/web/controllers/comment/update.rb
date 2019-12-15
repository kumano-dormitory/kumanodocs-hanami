# ====
# 議事録の投稿アクション
# ====
# ブロック会議の議事録の投稿を行う
# = 主な処理
# - 新規投稿時には、パスワードと共に議事録を保存する
# - 既に議事録が存在する場合には、パスワードで認証を行ってから保存する

module Web::Controllers::Comment
  class Update
    include Web::Action
    expose :meeting, :block_id, :requested_datas

    params do
      required(:meeting).schema do
        required(:articles) {
          array? {
            each {
              required(:article_id).filled(:int?)
              required(:comment).maybe(:str?)
              optional(:vote_result).schema do
                required(:agree) { filled? & int? & gteq?(0) }
                required(:disagree) { filled? & int? & gteq?(0) }
                required(:onhold) { filled? & int? & gteq?(0) }
              end
            }
          }
        }
      end
      required(:meeting_id).filled(:int?)
      required(:block_id).filled(:int?)
      required(:comments).schema do
        required(:password).filled(:str?)
      end
    end

    def initialize(meeting_repo: MeetingRepository.new,
                   comment_repo: CommentRepository.new,
                   vote_result_repo: VoteResultRepository.new,
                   authenticator: JwtAuthenticator.new)
      @meeting_repo = meeting_repo
      @comment_repo = comment_repo
      @vote_result_repo = vote_result_repo
      @authenticator = authenticator
      @notifications = {}
    end

    def call(params)
      @meeting = @meeting_repo.find_with_articles(params[:meeting_id])
      if params.valid?
        create_datas = []
        update_datas = []
        create_vote_datas = []
        update_vote_datas = []
        authentication_err = false

        # 議事録が投稿できるブロック会議が判定
        not_during_meeting_err = !during_meeting?(meeting: @meeting)

        # 議事録データの取り出し
        params[:meeting][:articles].each do |data|
          props = {article_id: data[:article_id], block_id: params[:block_id], body: (data[:comment] || '')}
          comment = @comment_repo.find(props[:article_id], params[:block_id])
          if comment.nil?
            # 議事録が存在しなければ新規作成する。
            create_datas << props.merge(
              crypt_password: Comment.crypt(params[:comments][:password])
            ) unless props[:body].empty?
          else
            if comment.authenticate(params[:comments][:password])
              update_datas << props.merge(id: comment.id)
            else
              authentication_err = true
            end
          end
          # 採決結果のデータ取り出し処理
          if data[:vote_result]
            props.delete(:body)
            props.merge!(data[:vote_result])
            vote_result = @vote_result_repo.find(props[:article_id], props[:block_id])
            if vote_result.nil?
              # 採決結果が存在しないので新規作成
              create_vote_datas << props.merge(crypt_password: VoteResult.crypt(params[:comments][:password]))
            else
              if vote_result.authenticate(params[:comments][:password])
                update_vote_datas << props.merge(id: vote_result.id)
              else
                authentication_err = true
              end
            end
          end
        end
        # 制御処理
        if not_during_meeting_err # ブロック会議中ではないため投稿不可
          @notifications = {error: {status: "Error:", message: "ブロック会議の開催中ではないため、議事録を投稿できません"}}
          @requested_datas = params[:meeting][:articles]
          @block_id = params[:block_id]
          self.status = 422
        elsif authentication_err # 議事録のパスワードエラー
          @block_id = params[:block_id]
          @requested_datas = params[:meeting][:articles]
          @notifications = {error: {status: "Authentication Failed:", message: "議事録のパスワードが間違っています. 正しいパスワードを入力してください. また、今回が初めての投稿の場合は既に議事録が投稿されています"}}
          self.status = 422
        else
          # 正常終了
          @comment_repo.create_list(create_datas) unless create_datas.empty?
          @comment_repo.update_list(update_datas) unless update_datas.empty?
          @vote_result_repo.create_list(create_vote_datas) unless create_vote_datas.empty?
          @vote_result_repo.update_list(update_vote_datas) unless update_vote_datas.empty?
          flash[:notifications] = {success: {status: "Success", message: "正常に議事録が投稿されました"}}
          redirect_to routes.root_path
        end
      else
        # invalid params
        @block_id = params[:block_id]
        @requested_datas = params[:meeting][:articles]
        @notifications = {error: {status: "Error:", message: "入力された項目に不備があります. もう一度確認してください"}}
        self.status = 422
      end
    end

    def notifications
      @notifications
    end
  end
end
