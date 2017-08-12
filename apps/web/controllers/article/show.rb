module Web::Controllers::Article
  class Show
    include Web::Action
    expose :article

    def initialize(article_repo: ArticleRepository.new)
      @article_repo = article_repo
    end

    def call(params)
      @article = @article_repo.find_with_relations(params[:id])
    end
  end
end
