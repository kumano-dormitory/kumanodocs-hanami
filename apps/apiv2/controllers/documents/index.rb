module Apiv2::Controllers::Documents
  class Index
    include Apiv2::Action
    accept :jsonapi

    def initialize(jsonapi_repo: JsonapiRepository.new,
                   authenticator: JwtAuthenticator.new)
      @jsonapi_repo = jsonapi_repo
      @authenticator = authenticator
    end

    def call(params)
      documents = @jsonapi_repo.documents_list.map do |document|
        {
          type: 'documents',
          id: document[:id],
          attributes: document
        }
      end
      self.body = JSON.generate({
        data: documents
      })
      self.format = :jsonapi
    end
  end
end
