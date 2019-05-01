module Web::Controllers::Comment
  class Update
    include Web::Action
    expose :meeting, :block_id, :comment_datas

    params do
      required(:meeting).schema do
        required(:articles) { array? }
      end
      required(:meeting_id).filled(:int?)
      required(:block_id).filled(:int?)
      required(:comments).schema do
        required(:password).filled(:str?)
      end
    end

    def initialize(meeting_repo: MeetingRepository.new,
                   comment_repo: CommentRepository.new)
      @meeting_repo = meeting_repo
      @comment_repo = comment_repo
      @notifications = {}
    end

    def call(params)
      @meeting = @meeting_repo.find_with_articles(params[:meeting_id])
      if params.valid?
        create_datas = []
        update_datas = []
        authentication_err = false

        # 議事録が投稿できるブロック会議が判定
        not_during_meeting_err = !during_meeting?(meeting: @meeting)

        # 議事録データの取り出し
        params[:meeting][:articles].each do |data|
          props = {article_id: data['article_id'], block_id: params[:block_id], body: data['comment']}
          comment = @comment_repo.find(props[:article_id], props[:block_id])
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
        end
        # 制御処理
        if not_during_meeting_err # ブロック会議中ではないため投稿不可
          @notifications = {error: {status: "Error:", message: "ブロック会議の開催中ではないため、議事録を投稿できません"}}
          @comment_datas = params[:meeting][:articles].map do |data|
            { article_id: data['article_id'].to_i, comment: data['comment'] }
          end
          @block_id = params[:block_id]
          self.status = 422
        elsif authentication_err # 議事録のパスワードエラー
          @block_id = params[:block_id]
          @comment_datas = params[:meeting][:articles].map do |data|
            { article_id: data['article_id'].to_i, comment: data['comment'] }
          end
          @notifications = {error: {status: "Authentication Failed:", message: "議事録のパスワードが間違っています. 正しいパスワードを入力してください. また、今回が初めての投稿の場合は既に議事録が投稿されています"}}
          self.status = 422
        else
          # 正常終了
          @comment_repo.create_list(create_datas) unless create_datas.empty?
          @comment_repo.update_list(update_datas) unless update_datas.empty?
          flash[:notifications] = {success: {status: "Success", message: "正常に議事録が投稿されました"}}
          redirect_to routes.root_path
        end
      else
        # invalid params
        @block_id = params[:block_id]
        @comment_datas = params[:meeting][:articles]&.map do |data|
          { article_id: data['article_id'].to_i, comment: data['comment'] }
        end
        @notifications = {error: {status: "Error:", message: "入力された項目に不備があります. もう一度確認してください"}}
        self.status = 422
      end
    end

    def notifications
      @notifications
    end
  end
end
