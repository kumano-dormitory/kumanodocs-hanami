module Web::Controllers::Docs
  module Login
    class New
      include Web::Action

      def initialize(authenticator: JwtAuthenticator.new)
        @authenticator = authenticator
      end

      def call(params)
      end
    end
  end
end
