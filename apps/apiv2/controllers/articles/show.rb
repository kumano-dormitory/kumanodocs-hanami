module Apiv2::Controllers::Articles
  class Show
    include Apiv2::Action
    accept :jsonapi

    params do
      required(:id) { filled? & int? & gt?(0) }
    end

    def initialize(jsonapi_repo: JsonapiRepository.new,
                   authenticator: JwtAuthenticator.new)
      @jsonapi_repo = jsonapi_repo
      @authenticator = authenticator
    end

    def call(params)
      if params.valid?
        article = @jsonapi_repo.article_details(params[:id])
        halt 404, '{}' unless article
        self.body = JSON.generate({
          data: {
            type: 'articles',
            id: article[:id],
            attributes: article
          }
        })
        self.format = :jsonapi
      else
        self.body = '{}'
        self.format = :jsonapi
        self.status = 404
      end
    end
  end
end
