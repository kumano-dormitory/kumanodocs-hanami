module Admin::Controllers::Sessions
  class Create
    include Admin::Action
    expose :name

    params do
      required(:session).schema do
        required(:name).filled(:str?)
        required(:password).filled(:str?)
      end
    end

    def initialize(user_repo: UserRepository.new)
      @user_repo = user_repo
      @notifications = {}
    end

    def call(params)
      if params.valid?
        user = @user_repo.find_by_name(params[:session][:name])
        if !user.nil? && user.authenticate(params[:session][:password])
          session[:user_id] = user.id
          redirect_to routes.root_path
        else
          @notifications = {error: {status: "Authentication Failed:", message: "ユーザー名またはパスワードが間違っています. もう一度入力してください"}}
        end
      else
        @notifications = {error: {status: "Error:", message: "入力された項目に不備があります. もう一度確認してください"}}
      end
      @name = params[:session][:name]
    end

    def authenticate!
      # do nothing
    end

    def navigation
      @navigation = {login: true}
    end

    def notifications
      @notifications
    end
  end
end
