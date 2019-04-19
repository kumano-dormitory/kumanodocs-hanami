module Web::Controllers::Article
  class Search
    include Web::Action
    expose :articles, :keywords, :page, :max_page

    def initialize(article_repo: ArticleRepository.new, limit: 20)
      @article_repo = article_repo
      @limit = limit
    end

    def call(params)
      @page = params[:page].nil? ? 1 : params[:page].to_i
      @keywords = ""
      keywords_array = ['']
      unless (params.nil? || params[:search_article].nil? || params[:search_article][:keywords].nil?)
        @keywords = params[:search_article][:keywords]
        keywords_array = @keywords.split(/[[:space:]]+/)
        if keywords_array.empty? then keywords_array = [''] end
      end
      search_count = @article_repo.search_count(keywords_array)
      @articles = @article_repo.search(keywords_array, page, @limit)
      @max_page = if search_count == 0 then 1 else (search_count - 1) / @limit + 1 end
    end
  end
end
