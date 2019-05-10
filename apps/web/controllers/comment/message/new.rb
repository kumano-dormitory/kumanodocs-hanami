module Web::Controllers::Comment
  module Message
    class New
      include Web::Action
      expose :comment, :view_type, :is_article_author

      params do
        required(:role) { filled? & str? & included_in?(['article-author', 'comment-author']) }
      end

      def initialize(comment_repo: CommentRepository.new)
        @comment_repo = comment_repo
      end

      def call(params)
        @comment = @comment_repo.find_by_id(params[:comment_id])
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
