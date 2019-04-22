module Admin::Controllers::Sessions
  class Destroy
    include Admin::Action

    def call(params)
      session[:user_id] = nil
      redirect_to '/'
    end
  end
end
