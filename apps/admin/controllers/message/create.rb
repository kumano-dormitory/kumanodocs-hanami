module Admin::Controllers::Message
  class Create
    include Admin::Action
    expose :comment, :messages

    params do
      required(:article_id).filled(:int?)
      required(:comment_id).filled(:int?)
      required(:message).schema do
        required(:send_by_article_author).filled(:bool?)
        required(:body).filled(:str?)
      end
    end

    def initialize(article_repo: ArticleRepository.new,
                   comment_repo: CommentRepository.new,
                   message_repo: MessageRepository.new,
                   admin_history_repo: AdminHistoryRepository.new)
      @article_repo = article_repo
      @comment_repo = comment_repo
      @message_repo = message_repo
      @admin_history_repo = admin_history_repo
    end

    def call(params)
      @comment = @comment_repo.find_with_relations(params[:comment_id])
      if params.valid?
        article = @article_repo.find(@comment.article_id)
        halt 400 unless article.id == params[:article_id]

        props = params[:message].merge({comment_id: @comment.id, author_id: article.author_id})
        @message_repo.create(props)
        @admin_history_repo.add(:message_create,
          JSON.pretty_generate({action:"message_create", payload:{message: props}})
        )
        flash[:notifications] = {success: {status: 'Success:', message: '正常に議事録に対する返答が送信されました'}}
        redirect_to routes.meeting_article_path(meeting_id: article.meeting_id, id: article.id)
      else
        @messages = @message_repo.by_article(@comment.article_id).group_by{|message| message.comment_id}
        @notifications = {error: {status: 'Error', message: '入力された項目に不備があります'}}
      end
    end

    def notifications
      @notifications
    end
  end
end
