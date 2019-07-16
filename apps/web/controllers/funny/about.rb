module Web::Controllers::Funny
  class About
    include Web::Action

    def initialize(authenticator: JwtAuthenticator.new)
      @authenticator = authenticator
    end

    def call(params)
    end
  end
end
