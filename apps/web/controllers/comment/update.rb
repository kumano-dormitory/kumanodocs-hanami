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

    params Class.new(Hanami::Action::Params) {
      predicate(:valid_hash?, message: 'is not valid data'){ |current|
        return false unless current.instance_of?(Hash)

        current.each do |key, data|
          p key
          p data
          # required(:article_id).filled(:int?)
          if !data.key?("article_id") || !data["article_id"].match(/\d+|/)
            return false
          else
            data[:article_id] = data["article_id"].to_i
            data.delete("article_id")
          end
          # required(:comment).maybe(:str?)
          if !data.key?("comment")
            return false
          else
            data[:comment] = data["comment"]
            data.delete("comment")
          end
          # optional(:vote_reject).filled(:str?)
          if data.key?("vote_reject")
            data[:vote_reject] = data["vote_reject"]
            data.delete("vote_reject")
          end
          # optional(:vote_result)
          if data.key?("vote_result")
            vr = data["vote_result"]
            if !vr&.key?("agree") || !vr["agree"].match(/\d+|/) || vr["agree"].to_i < 0
              return false
            else
              vr[:agree] = vr["agree"].to_i
              vr.delete("agree")
            end
            if !vr&.key?("disagree") || !vr["disagree"].match(/\d+|/) || vr["disagree"].to_i < 0
              return false
            else
              vr[:disagree] = vr["disagree"].to_i
              vr.delete("disagree")
            end
            if !vr&.key?("onhold") || !vr["onhold"].match(/\d+|/) || vr["onhold"].to_i < 0
              return false
            else
              vr[:onhold] = vr["onhold"].to_i
              vr.delete("onhold")
            end
            data[:vote_result] = data["vote_result"]
            data.delete("vote_result")
          end
          # optional(:vote_reject_reason).maybe(:str?)
          if data.key?("vote_reject_reason")
            data[:vote_reject_reason] = data["vote_reject_reason"]
            data.delete("vote_reject_reason")
          end
        end
        return true
      }

      validations do
        required(:meeting).schema do
          required(:articles) { valid_hash? }
        end
        required(:meeting_id).filled(:int?)
        required(:block_id).filled(:int?)
        required(:comments).schema do
          required(:password).filled(:str?)
        end
      end
    }

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
        params[:meeting][:articles].each do |idx, data|
          props = {article_id: data[:article_id], block_id: params[:block_id], body: (data[:comment] || '')}
          # 採決拒否の場合には採決拒否の理由を議事録に含める
          if data[:vote_reject] && data[:vote_reject] == "reject"
            if data[:vote_reject_reason] && !data[:vote_reject_reason].empty?
              props[:body] = "#{props[:body]}\n\n採決拒否の理由\n#{data[:vote_reject_reason]}"
            end
          end
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
        @requested_datas = params[:meeting][:articles]&.to_a&.map{|t| t[1]}
        @notifications = {error: {status: "Error:", message: "入力された項目に不備があります. もう一度確認してください"}}
        self.status = 422
      end
    end

    def notifications
      @notifications
    end
  end
end
