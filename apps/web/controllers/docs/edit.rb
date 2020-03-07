module Web::Controllers::Docs
  class Edit
    include Web::Action
    expose :document

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
      @document = @document_repo.find_with_relations(params[:id])
      unless !user.nil? && user.authority == 1 && user.id == @document&.user_id
        redirect_to routes.new_login_docs_path
      end
    end
  end
end
