module Super::Controllers::User
  class Update
    include Super::Action
    expose :user

    params do
      required(:user).schema do
        required(:password).maybe(:str?).confirmation
        required(:authority).filled(:int?, included_in?: 0..2)
      end
    end

    def initialize(user_repo: UserRepository.new)
      @user_repo = user_repo
    end

    def call(params)
      if params.valid?
        props = { authority: params[:user][:authority] }
        if params[:user][:password]
          props.merge!(crypt_password: User.crypt(params[:user][:password]))
        end

        @user_repo.update(params[:id], props)
        redirect_to routes.user_path(id: params[:id])
      end
    end
  end
end
