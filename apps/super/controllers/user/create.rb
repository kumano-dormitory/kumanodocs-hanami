module Super::Controllers::User
  class Create
    include Super::Action

    params do
      required(:user).schema do
        required(:name).filled(:str?)
        required(:password).filled(:str?).confirmation
        required(:password_confirmation).filled(:str?)
        required(:authority).filled(:int?, included_in?: 0..3)
      end
    end

    def initialize(user_repo: UserRepository.new)
      @user_repo = user_repo
    end

    def call(params)
      # バリデーションを通り、ユーザ名が使用されていない場合はユーザを追加する
      if params.valid? && !@user_repo.find_by_name(params[:user][:name])
        user_props = {
          name: params[:user][:name],
          crypt_password: User.crypt(params[:user][:password]),
          authority: params[:user][:authority]
        }
        @user_repo.create(user_props)
        redirect_to routes.users_path
      end
    end
  end
end
