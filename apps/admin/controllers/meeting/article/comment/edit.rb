module Admin::Controllers::Meeting
  module Article
    module Comment
      class Edit
        include Admin::Action
        expose :article, :block, :comment, :vote_result

        def initialize(article_repo: ArticleRepository.new,
                       block_repo: BlockRepository.new,
                       comment_repo: CommentRepository.new,
                       vote_result_repo: VoteResultRepository.new,
                       authenticator: AdminAuthenticator.new)
          @article_repo = article_repo
          @block_repo = block_repo
          @comment_repo = comment_repo
          @vote_result_repo = vote_result_repo
          @authenticator = authenticator
        end

        def call(params)
          @article = @article_repo.find_with_relations(params[:article_id])
          @block = @block_repo.find(params[:block_id])
          @comment = @comment_repo.find(params[:article_id], params[:block_id])
          if @article.categories.find{ |category| category.require_content && category.name == '採決' }
            @vote_result = @vote_result_repo.find(params[:article_id], params[:block_id]) || VoteResult.new
          end
        end
      end
    end
  end
end
