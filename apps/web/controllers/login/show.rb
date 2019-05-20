module Web::Controllers::Login
  class Show
    include Web::Action
    expose :standalone

    def call(params)
      @standalone = !!params[:standalone]
      if @standalone && authenticated?
        redirect_to routes.root_path
      end
    end

    def authenticate!
      # do nothing
    end
  end
end
