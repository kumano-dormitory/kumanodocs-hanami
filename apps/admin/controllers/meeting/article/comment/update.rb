module Admin::Controllers::Meeting
  module Article
    module Comment
      class Update
        include Admin::Action
        expose :article, :block, :comment

        params do
          required(:article_id).filled(:int?)
          required(:block_id).filled(:int?)
          required(:comment).schema do
            required(:body).filled(:str?)
          end
        end

        def initialize(article_repo: ArticleRepository.new,
                       block_repo: BlockRepository.new,
                       comment_repo: CommentRepository.new)
          @article_repo = article_repo
          @block_repo = block_repo
          @comment_repo = comment_repo
          @notifications = {}
        end

        def call(params)
          if params.valid?
            props = {
              article_id: params[:article_id],
              block_id: params[:block_id],
              body: params[:comment][:body]
            }
            comment = @comment_repo.find(params[:article_id], params[:block_id])
            if comment.nil?
              # 議事録が存在しない
              @comment_repo.create(props.merge({crypt_password: '1'}))
            else
              # 議事録のupdate
              @comment_repo.update(comment.id, props)
            end
            flash[:notifications] = {success: {status: "Success:", message: "正常に議事録が編集されました"}}
            redirect_to routes.meeting_article_path(meeting_id: 0, id: params[:article_id])
          else
            @article = @article_repo.find(params[:article_id])
            @block = @block_repo.find(params[:block_id])
            @comment = @comment_repo.find(params[:article_id], params[:block_id])
            @notifications = {error: {status: "Error:", message: "入力された項目に不備があります. もう一度確認してください"}}
            self.status = 422
          end
        end

        def notifications
          @notifications
        end
      end
    end
  end
end
