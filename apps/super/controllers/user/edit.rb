module Super::Controllers::User
  class Edit
    include Super::Action
    expose :user

    def initialize(user_repo: UserRepository.new)
      @user_repo = user_repo
    end

    def call(params)
      @user = @user_repo.find(params[:id])
    end
  end
end
