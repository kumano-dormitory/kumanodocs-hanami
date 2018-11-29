module Admin::Controllers::Meeting
  module Article
    module Comment
      class Edit
        include Admin::Action
        expose :article, :block, :comment

        def initialize(article_repo: ArticleRepository.new,
                       block_repo: BlockRepository.new,
                       comment_repo: CommentRepository.new)
          @article_repo = article_repo
          @block_repo = block_repo
          @comment_repo = comment_repo
        end

        def call(params)
          @article = @article_repo.find(params[:article_id])
          @block = @block_repo.find(params[:block_id])
          @comment = @comment_repo.find(params[:article_id], params[:block_id])
        end
      end
    end
  end
end
