module Web::Controllers::Login
  class Show
    include Web::Action
    expose :standalone, :invalid_token

    def call(params)
      @standalone = !!params[:standalone]
      @invalid_token = !!params[:invalid]
      if @standalone && authenticated?
        redirect_to routes.root_path
      end
    end

    def authenticate!
      # do nothing
    end
  end
end
