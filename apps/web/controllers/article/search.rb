module Web::Controllers::Article
  class Search
    include Web::Action
    expose :articles, :keywords, :page, :max_page, :detail_search, :categories

    params do
      optional(:page).filled(:int?)
      optional(:detail_search).filled(:bool?)
      required(:search_article).schema do
        optional(:keywords).maybe(:str?)
        required(:title).maybe(:str?)
        required(:body).maybe(:str?)
        required(:author).maybe(:str?)
        optional(:categories).each(:int?)
        required(:detail_search).filled(:bool?)
      end
    end

    def initialize(article_repo: ArticleRepository.new,
                   category_repo: CategoryRepository.new,
                   limit: 20)
      @article_repo = article_repo
      @category_repo = category_repo
      @limit = limit
    end

    def call(params)
      @detail_search = !!params[:detail_search]
      @page = params[:page].nil? ? 1 : params[:page].to_i

      if params.valid? && ( @detail_search || params[:search_article][:detail_search] )
        @detail_search = true
        title_query = params[:search_article][:title] || ''
        body_query = params[:search_article][:body] || ''
        author_query = params[:search_article][:author] || ''
        category_query = params[:search_article][:categories] || []
        @keywords = {title: title_query, body: body_query, author: author_query, categories: category_query}
        search_count = @article_repo.search_count(@keywords, detail_search: true)
        @articles = @article_repo.search(@keywords, page, @limit, detail_search: true)
      else
        @keywords = ""
        keywords_array = ['']
        unless (params.nil? || params[:search_article].nil? || params[:search_article][:keywords].nil?)
          @keywords = params[:search_article][:keywords]
          keywords_array = @keywords.split(/[[:space:]]+/)
          if keywords_array.empty? then keywords_array = [''] end
        end
        search_count = @article_repo.search_count(keywords_array)
        @articles = @article_repo.search(keywords_array, page, @limit)
      end

      @max_page = if search_count == 0 then 1 else (search_count - 1) / @limit + 1 end
      @categories = @category_repo.all
    end

    def navigation
      @navigation = {bn_search: true}
    end
  end
end
