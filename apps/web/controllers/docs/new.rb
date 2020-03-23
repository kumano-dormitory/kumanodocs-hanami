module Web::Controllers::Docs
  class New
    include Web::Action
    expose :user

    def initialize(user_repo: UserRepository.new,
                   authenticator: JwtAuthenticator.new)
      @user_repo = user_repo
      @authenticator = authenticator
    end

    def call(params)
      if !session[:user_id].nil?
        @user = @user_repo.find(session[:user_id])
      else
        redirect_to routes.new_login_docs_path
      end
    end
  end
end
