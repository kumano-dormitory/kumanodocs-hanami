module Super::Controllers::Session
  class Destroy
    include Super::Action

    def call(params)
      session[:user_id] = nil
      redirect_to '/'
    end
  end
end
