module Apiv2::Controllers::Articles
  class Search
    include Apiv2::Action
    accept :jsonapi

    DEFAULT_LIMIT = 20

    params do
      optional(:q).maybe(:str?)
      optional(:limit) { filled? & int? & gt?(0) }
      optional(:offset) { filled? & int? & gteq?(0) }
    end


    def initialize(jsonapi_repo: JsonapiRepository.new,
                   authenticator: JwtAuthenticator.new)
      @jsonapi_repo = jsonapi_repo
      @authenticator = authenticator
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

        total = @jsonapi_repo.search_articles_count(keywords: keywords_array)

        data = @jsonapi_repo.search_articles(keywords: keywords_array, limit: limit, offset: offset).map do |article|
          {
            type: 'article-search-results',
            id: article[:id],
            attributes: article
          }
        end
        self.format = :jsonapi
        self.body = JSON.generate({
          data: data,
          meta: { total: total }
        })
      else
        self.body = '{}'
        self.format = :jsonapi
        self.status = 400
      end
    end
  end
end
