module Web::Controllers::Docs
  class Show
    include Web::Action
    expose :document

    def initialize(document_repo: DocumentRepository.new,
                   authenticator: JwtAuthenticator.new)
      @document_repo = document_repo
      @authenticator = authenticator
    end

    def call(params)
      @document = @document_repo.find_with_relations(params[:id])
    end

    def navigation
      @navigation = {docs: true}
    end
  end
end
