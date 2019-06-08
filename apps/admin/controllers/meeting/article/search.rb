module Admin::Controllers::Meeting
  module Article
    class Search
      include Admin::Action
      expose :articles, :keywords, :page, :max_page

      params do
        required(:query).filled(:str?)
        optional(:page).filled(:int?)
      end

      def initialize(article_repo: ArticleRepository.new, limit: 20)
        @article_repo = article_repo
        @limit = limit
      end

      def call(params)
        @page = params[:page].nil? ? 1 : params[:page].to_i
        @keywords = ""
        keywords_array = ['']
        if params.valid? && !params[:query].strip.empty?
          @keywords = params[:query]
          keywords_array = @keywords.split(/[[:space:]]+/)
          if keywords_array.empty? then keywords_array = [''] end
        end
        search_count = @article_repo.search_count(keywords_array)
        @articles = @article_repo.search(keywords_array, page, @limit)
        @max_page = if search_count == 0 then 1 else (search_count - 1) / @limit + 1 end
      end
    end
  end
end
