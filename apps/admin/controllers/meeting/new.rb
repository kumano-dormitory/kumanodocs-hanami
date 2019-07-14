module Admin::Controllers::Meeting
  class New
    include Admin::Action

    def initialize(authenticator: AdminAuthenticator.new)
      @authenticator = authenticator
    end

    def call(params)
    end
  end
end
