module Admin::Controllers::Docs
  class Show
    include Admin::Action
    expose :document

    def initialize(document_repo: DocumentRepository.new,
                   authenticator: AdminAuthenticator.new)
      @document_repo = document_repo
      @authenticator = authenticator
    end

    def call(params)
      @document = @document_repo.find_with_relations(params[:id])
    end
  end
end
