module Admin::Controllers::Message
  class Update
    include Admin::Action
    expose :comment, :messages, :message

    params do
      required(:article_id).filled(:int?)
      required(:comment_id).filled(:int?)
      required(:id).filled(:int?)
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
      @comment = @comment_repo.find_by_id(params[:comment_id])
      @message = @message_repo.find(params[:id])
      if params.valid?
        article = @article_repo.find(params[:article_id])
        halt 400 unless @comment.article_id == params[:article_id] && @message.comment_id == params[:comment_id]

        props = params[:message]
        message_ret = @message_repo.update(@message.id, params[:message])
        @admin_history_repo.add(:message_update,
          JSON.pretty_generate({action:"message_update", payload:{message_before: @message.to_h, message_after: message_ret.to_h}})
        )
        flash[:notifications] = {success: {status: 'Success:', message: '正常に議事録に対する返答が更新されました'}}
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
