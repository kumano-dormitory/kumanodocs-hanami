module Admin::Controllers::Docs
  class Destroy
    include Admin::Action
    expose :document

    params do
      required(:id).filled(:int?)
      required(:document).schema do
        required(:confirm).filled(:bool?)
      end
    end

    def initialize(document_repo: DocumentRepository.new,
                   authenticator: AdminAuthenticator.new)
      @document_repo = document_repo
      @authenticator = authenticator
    end

    def call(params)
      @document = @document_repo.find_with_relations(params[:id])
      halt 404 unless @document

      if params.valid? && params[:document][:confirm]
        @document_repo.delete(@document.id)
        redirect_to routes.docs_path
      end
    end
  end
end
