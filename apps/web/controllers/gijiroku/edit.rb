module Web::Controllers::Gijiroku
  class Edit
    include Web::Action
    expose :gijiroku

    def initialize(gijiroku_repo: GijirokuRepository.new,
                   authenticator: JwtAuthenticator.new)
      @gijiroku_repo = gijiroku_repo
      @authenticator = authenticator
    end

    def call(params)
      @gijiroku = @gijiroku_repo.find(params[:id])
    end
  end
end
