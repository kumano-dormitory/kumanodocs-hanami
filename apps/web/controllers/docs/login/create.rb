module Web::Controllers::Docs
  module Login
    class Create
      include Web::Action

      params do
        required(:user).schema do
          required(:name).filled(:str?)
          required(:password).filled(:str?)
        end
      end

      def initialize(user_repo: UserRepository.new,
                     authenticator: JwtAuthenticator.new)
        @user_repo = user_repo
        @authenticator = authenticator
      end

      def call(params)
        user = @user_repo.find_by_name(params[:user][:name])
        if !user.nil? && user.authority == 1 && user.authenticate(params[:user][:password])
          session.clear
          session[:user_id] = user.id
          redirect_to routes.editor_menu_documents_path
        else
          flash[:notifications] = {error: {status: "Authentication Failed:", message: "ユーザー名またはパスワードが間違っています. もう一度入力してください"}}
        end
      end
    end
  end
end
