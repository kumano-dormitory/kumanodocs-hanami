module Web::Controllers::Login
  class Show
    include Web::Action
    expose :standalone

    def call(params)
      @standalone = !!params[:standalone]
    end

    def authenticate!
      # do nothing
    end
  end
end
