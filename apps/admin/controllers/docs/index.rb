module Admin::Controllers::Docs
  class Index
    include Admin::Action
    expose :documents

    def initialize(document_repo: DocumentRepository.new,
                   authenticator: AdminAuthenticator.new)
      @document_repo = document_repo
      @authenticator = authenticator
    end

    def call(params)
      @documents = @document_repo.order_by_number
    end
  end
end
