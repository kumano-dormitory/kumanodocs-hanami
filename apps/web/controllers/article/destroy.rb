module Web::Controllers::Article
  class Destroy
    include Web::Action

    def initialize(article_repo: ArticleRepository.new)
      @article_repo = article_repo
    end

    def call(params)
      @article_repo.delete(params[:id])
      redirect_to routes.articles_path
    end
  end
end
