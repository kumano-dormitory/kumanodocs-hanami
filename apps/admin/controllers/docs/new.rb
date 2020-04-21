module Admin::Controllers::Docs
  class New
    include Admin::Action
    expose :users

    def initialize(user_repo: UserRepository.new,
                   authenticator: AdminAuthenticator.new)
      @user_repo = user_repo
      @authenticator = authenticator
    end

    def call(params)
      @users = @user_repo.by_authority(1)
    end
  end
end
