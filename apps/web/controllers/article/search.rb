module Web::Controllers::Article
  class Search
    include Web::Action
    expose :articles, :keyword

    def initialize(article_repo: ArticleRepository.new)
      @article_repo = article_repo
    end

    def call(params)
      if (params[:search_article][:keyword].nil?)
        @articles = @article_repo.all
        @keyword = ""
      else
        @articles = @article_repo.search(params[:search_article][:keyword])
        @keyword = params[:search_article][:keyword]
      end
    end
  end
end
