module Apiv2::Controllers::Articles
  class Search
    include Apiv2::Action
    accept :jsonapi

    DEFAULT_LIMIT = 20

    params do
      optional(:q).maybe(:str?)
      optional(:qauthor).maybe(:str?)
      optional(:qbody).maybe(:str?)
      optional(:qcat1).filled(:bool?)
      optional(:qcat2).filled(:bool?)
      optional(:qcat3).filled(:bool?)
      optional(:qcat4).filled(:bool?)
      optional(:qcat5).filled(:bool?)
      optional(:detail_search).filled(:bool?)
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
        if params[:detail_search]
          p params
          # 議案の詳細検索
          title_keywords = ['']
          if params[:q]
            title_keywords = params[:q].split(/[[:space:]]+/)
            if title_keywords.empty? then title_keywords = [''] end
          end
          author_keywords = ['']
          if params[:qauthor]
            author_keywords = params[:qauthor].split(/[[:space:]]+/)
            if author_keywords.empty? then author_keywords = [''] end
          end
          body_keywords = ['']
          if params[:qbody]
            body_keywords = params[:qbody].split(/[[:space:]]+/)
            if body_keywords.empty? then body_keywords = [''] end
          end
          category_ids = []
          category_ids.push 1 if params[:qcat1]
          category_ids.push 2 if params[:qcat2]
          category_ids.push 3 if params[:qcat3]
          category_ids.push 4 if params[:qcat4]
          category_ids.push 5 if params[:pcat5]

          limit = params[:limit] || DEFAULT_LIMIT
          offset = params[:offset] || 0

          total = @jsonapi_repo.detail_search_articles_count(
            title_keywords: title_keywords, author_keywords: author_keywords, body_keywords: body_keywords, category_ids: category_ids
          )

          data = @jsonapi_repo.detail_search_articles(
            title_keywords: title_keywords, author_keywords: author_keywords, body_keywords: body_keywords,
            category_ids: category_ids, limit: limit, offset: offset
          ).map do |article|
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
          # 議案の簡易検索
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
        end
      else
        self.body = '{}'
        self.format = :jsonapi
        self.status = 400
      end
    end
  end
end
