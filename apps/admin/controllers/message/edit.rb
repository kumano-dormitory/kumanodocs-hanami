module Admin::Controllers::Message
  class Edit
    include Admin::Action
    expose :comment, :messages, :message

    params do
      required(:comment_id).filled(:int?)
      required(:id).filled(:int?)
    end

    def initialize(comment_repo: CommentRepository.new,
                   message_repo: MessageRepository.new)
      @comment_repo = comment_repo
      @message_repo = message_repo
    end

    def call(params)
      halt 400 unless params.valid?

      @comment = @comment_repo.find_with_relations(params[:comment_id])
      @message = @message_repo.find(params[:id])
      @messages = @message_repo.by_article(@comment.article_id).group_by{|message| message.comment_id}
    end
  end
end
