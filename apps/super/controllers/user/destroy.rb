module Super::Controllers::User
  class Destroy
    include Super::Action

    def initialize(user_repo: UserRepository.new)
      @user_repo = user_repo
    end

    def call(params)
      @user = @user_repo.find(params[:id])
      @user_repo.delete(@user.id) if @user

      redirect_to routes.users_path
    end
  end
end
