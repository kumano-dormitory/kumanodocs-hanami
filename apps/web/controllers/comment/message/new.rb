module Web::Controllers::Comment
  module Message
    class New
      include Web::Action
      expose :comment, :messages, :view_type, :is_article_author

      params do
        required(:role) { filled? & str? & included_in?(['article-author', 'comment-author']) }
      end

      def initialize(comment_repo: CommentRepository.new,
                     message_repo: MessageRepository.new)
        @comment_repo = comment_repo
        @message_repo = message_repo
      end

      def call(params)
        @comment = @comment_repo.find_with_relations(params[:comment_id])
        @messages = @message_repo.by_article(@comment.article_id).group_by{|message| message.comment_id}
        if params.valid?
          if params[:role] == 'article-author'
            @is_article_author = true
          elsif params[:role] == 'comment-author'
            @is_article_author = false
          end
          @view_type = :form
        else
          @view_type = :select_role
        end
      end
    end
  end
end
