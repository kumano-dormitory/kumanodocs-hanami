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
    end

    def call(params)
      if params.valid?
        user = @user_repo.find_by_name(params[:session][:name])
        if !user.nil? && user.authenticate(params[:session][:password])
          session[:user_id] = user.id
          redirect_to routes.meetings_path
        end
      end
      @name = params[:session][:name]
    end

    def authenticate!
      # do nothing
    end
  end
end
