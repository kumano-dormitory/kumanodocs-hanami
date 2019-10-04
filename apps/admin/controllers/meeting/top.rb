module Admin
  module Controllers
    module Meeting
      class Top
        include Admin::Action

        def initialize(authenticator: AdminAuthenticator.new)
          @authenticator = authenticator
        end

        def call(params)
        end

        def navigation
          @navigation = {root: true}
        end
      end
    end
  end
end
