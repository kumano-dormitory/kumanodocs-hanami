module Web::Controllers::Docs
  class EditorMenu
    include Web::Action
    expose :user, :documents

    def initialize(document_repo: DocumentRepository.new,
                   user_repo: UserRepository.new,
                   authenticator: JwtAuthenticator.new)
      @document_repo = document_repo
      @user_repo = user_repo
      @authenticator = authenticator
    end

    def call(params)
      redirect_to routes.new_login_docs_path unless session[:user_id]

      @user = @user_repo.find(session[:user_id])
      if !@user.nil? && @user.authority == 1
        @documents = @document_repo.by_user(@user.id)
      else
        redirect_to routes.new_login_docs_path
      end
    end
  end
end
