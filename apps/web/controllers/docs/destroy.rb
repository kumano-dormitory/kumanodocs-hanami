module Web::Controllers::Docs
  class Destroy
    include Web::Action
    expose :document

    params do
      required(:document).schema do
        required(:confirm).filled(:bool?)
      end
    end

    def initialize(document_repo: DocumentRepository.new,
                   user_repo: UserRepository.new,
                   authenticator: JwtAuthenticator.new)
      @document_repo = document_repo
      @user_repo = user_repo
      @authenticator = authenticator
    end

    def call(params)
      redirect_to routes.new_login_docs_path unless session[:user_id]

      user = @user_repo.find(session[:user_id])
      @document = @document_repo.find(params[:id])
      halt 404 unless @document

      if !user.nil? && user.authority == 1 && user.id == @document.user_id
        if params.valid? && params[:document][:confirm]
          @document_repo.delete(@document.id)
          redirect_to routes.editor_menu_documents_path
        end
      else
        redirect_to routes.new_login_docs_path
      end
    end
  end
end
