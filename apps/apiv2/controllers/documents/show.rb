module Apiv2::Controllers::Documents
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
        document = @jsonapi_repo.find_document(params[:id])
        halt 404, '{}' unless document

        self.body = JSON.generate({
          data: {
            type: 'documents',
            id: document[:id],
            attributes: document
          }
        })
        self.format = :jsonapi
      else
        self.body = '{}'
        self.status = 400
      end
    end
  end
end
