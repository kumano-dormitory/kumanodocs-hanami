module Super::Controllers::User
  class Index
    include Super::Action
    expose :users

    def initialize(user_repo: UserRepository.new)
      @user_repo = user_repo
    end

    def call(params)
      @users = @user_repo.all
    end
  end
end
