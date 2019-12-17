module Web::Controllers::Gijiroku
  class List
    include Web::Action
    expose :gijirokus

    def initialize(gijiroku_repo: GijirokuRepository.new,
                   authenticator: JwtAuthenticator.new)
      @gijiroku_repo = gijiroku_repo
      @authenticator = authenticator
    end

    def call(params)
      @gijirokus = @gijiroku_repo.all
    end
  end
end
