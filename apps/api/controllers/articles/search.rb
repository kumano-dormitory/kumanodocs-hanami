module Api::Controllers::Articles
  class Search
    include Api::Action

    DEFAULT_LIMIT = 25

    params do
      required(:token).filled(:str?)
      optional(:q) { filled? & str? }
      optional(:limit) { filled? & int? & gt?(0) & lt?(101) }
      optional(:offset) { filled? & int? & gteq?(0) }
    end

    def initialize(json_repo: JsonRepository.new)
      @json_repo = json_repo
    end

    def call(params)
      if params.valid?
        keywords_array = ['']
        if params[:q]
          keywords = params[:q]
          keywords_array = keywords.split(/[[:space:]]+/)
          if keywords_array.empty? then keywords_array = [''] end
        end
        limit = params[:limit] || DEFAULT_LIMIT
        offset = params[:offset] || 0

        articles = @json_repo.search_articles(keywords: keywords_array, limit: limit, offset: offset)
        self.body = JSON.pretty_generate({articles: articles})
        self.format = :json
      else
        self.status = 400
      end
    end
  end
end
