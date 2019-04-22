module Admin::Controllers::Sessions
  class New
    include Admin::Action

    def call(params)
    end

    def authenticate!
      # do nothing
    end

    def navigation
      @navigation = {login: true}
    end
  end
end
