module Super::Controllers::Session
  class Create
    include Super::Action
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
        if !user.nil? && user.authority == 3 && user.authenticate(params[:session][:password])
          session.clear
          session[:user_id] = user.id
          redirect_to routes.root_path
        end
      end
      @name = params[:session][:name]
    end

    def authenticate!
      # do nothing
    end
  end
end
