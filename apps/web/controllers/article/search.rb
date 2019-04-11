module Web::Controllers::Article
  class Search
    include Web::Action
    expose :articles, :keywords

    def initialize(article_repo: ArticleRepository.new)
      @article_repo = article_repo
    end

    def call(params)
      if ( params.nil? || params[:search_article].nil? || params[:search_article][:keywords].nil?)
        @articles = @article_repo.search([''])
        @keywords = ""
      else
        @keywords = params[:search_article][:keywords]
        keywords_array = @keywords.split(/[[:space:]]+/)
        @articles = @article_repo.search(keywords_array)
      end
    end
  end
end
