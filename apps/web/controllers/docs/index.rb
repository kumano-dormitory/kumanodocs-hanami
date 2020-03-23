module Web::Controllers::Docs
  class Index
    include Web::Action
    expose :documents

    def initialize(document_repo: DocumentRepository.new,
                   authenticator: JwtAuthenticator.new)
      @document_repo = document_repo
      @authenticator = authenticator
    end

    def call(params)
      @documents = @document_repo.order_by_number
    end
  end
end
