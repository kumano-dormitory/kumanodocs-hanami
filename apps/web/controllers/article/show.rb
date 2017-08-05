module Web::Controllers::Article
  class Show
    include Web::Action
    expose :article

    def initialize(article_repository: ArticleRepository.new)
      @article_repository = article_repository
    end

    def call(params)
      @article = @article_repository.find_with_author(params[:id])
    end
  end
end
