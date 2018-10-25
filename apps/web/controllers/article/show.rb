module Web::Controllers::Article
  class Show
    include Web::Action
    expose :article, :blocks

    def initialize(article_repo: ArticleRepository.new,
                   block_repo: BlockRepository.new)
      @article_repo = article_repo
      @block_repo = block_repo
    end

    def call(params)
      @article = @article_repo.find_with_relations(params[:id])
      @blocks = @block_repo.all
    end
  end
end
