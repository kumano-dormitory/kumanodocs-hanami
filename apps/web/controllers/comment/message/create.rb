module Web::Controllers::Comment
  module Message
    class Create
      include Web::Action
      expose :comment, :messages, :is_article_author

      params do
        required(:comment_id).filled(:int?)
        required(:message).schema do
          required(:password).filled(:str?)
          required(:body).filled(:str?)
          required(:send_by_article_author).filled(:bool?)
        end
      end

      def initialize(message_repo: MessageRepository.new,
                     article_repo: ArticleRepository.new,
                     comment_repo: CommentRepository.new,
                     authenticator: JwtAuthenticator.new)
        @message_repo = message_repo
        @article_repo = article_repo
        @comment_repo = comment_repo
        @authenticator = authenticator
        @notifications = {}
      end

      def call(params)
        @comment = @comment_repo.find_with_relations(params[:comment_id])
        @messages = @message_repo.by_article(@comment.article_id).group_by{|message| message.comment_id}
        if params.valid?
          article = @article_repo.find_with_relations(comment.article_id)
          if params[:message][:send_by_article_author]
            # 議案提起者として返答
            if article.author.authenticate(params[:message][:password])
              create(params, comment, article)
            else
              @notifications = {error: {status: 'Authentication failed', message: 'パスワードが不正です. 正しいパスワードを入力してください'}}
            end
          else
            # 議事録投稿者として返答
            if comment.authenticate(params[:message][:password])
              create(params, comment, article)
            else
              @notifications = {error: {status: 'Authentication failed', message: 'パスワードが不正です. 正しいパスワードを入力してください'}}
            end
          end
        else
          @notifications = {error: {status: 'Error', message: '入力された項目に不備があります. もう一度確認してください'}}
        end
        @is_article_author = params[:message][:send_by_article_author]
      end

      def notifications
        @notifications
      end

      private
      def create(params, comment, article)
        props = params[:message].merge(
          comment_id: comment.id,
          author_id: article.author.id
        )
        @message_repo.create(props)
        flash[:notifications] = {success: {status: 'Success:', message: '正常に議事録に対する返答が送信されました'}}
        redirect_to routes.article_path(id: article.id)
      end
    end
  end
end
