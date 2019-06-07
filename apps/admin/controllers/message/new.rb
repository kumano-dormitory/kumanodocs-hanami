module Admin::Controllers::Message
  class New
    include Admin::Action
    expose :comment, :messages

    params do
      required(:comment_id).filled(:int?)
    end

    def initialize(comment_repo: CommentRepository.new,
                   message_repo: MessageRepository.new)
      @comment_repo = comment_repo
      @message_repo = message_repo
    end

    def call(params)
      halt 404 unless params.valid?
      @comment = @comment_repo.find_with_relations(params[:comment_id])
      @messages = @message_repo.by_article(@comment.article_id).group_by{|message| message.comment_id}
    end
  end
end
