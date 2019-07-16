module Web::Controllers::Gijiroku
  class New
    include Web::Action

    def initialize(authenticator: JwtAuthenticator.new)
      @authenticator = authenticator
    end

    def call(params)
    end
  end
end
