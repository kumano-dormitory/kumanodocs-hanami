module Admin::Controllers::Sessions
  class Create
    include Admin::Action
    expose :name

    params do
      required(:session).schema do
        required(:adminname).filled(:str?)
        required(:password).filled(:str?)
      end
    end

    def initialize(user_repo: UserRepository.new,
                   admin_history_repo: AdminHistoryRepository.new)
      @user_repo = user_repo
      @admin_history_repo = admin_history_repo
      @notifications = {}
    end

    def call(params)
      if params.valid?
        user = @user_repo.find_by_name(params[:session][:adminname])
        if !user.nil? && user.authority == 2 && user.authenticate(params[:session][:password])
          session.clear
          session[:user_id] = user.id
          @admin_history_repo.add(:sessions_create, JSON.pretty_generate({action:"sessions_create", payload:{user_id: user.id}}))
          redirect_to routes.root_path
        else
          @notifications = {error: {status: "Authentication Failed:", message: "ユーザー名またはパスワードが間違っています. もう一度入力してください"}}
        end
      else
        @notifications = {error: {status: "Error:", message: "入力された項目に不備があります. もう一度確認してください"}}
      end
      @name = params[:session][:adminname]
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
