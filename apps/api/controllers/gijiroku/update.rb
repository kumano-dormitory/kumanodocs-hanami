module Api::Controllers::Gijiroku
  class Update
    include Api::Action

    params do
      optional(:token).filled(:str?)
      required(:content).filled(:str?)
    end

    def initialize(gijiroku_repo: GijirokuRepository.new,
                   authenticator: JwtAuthenticator.new)
      @gijiroku_repo = gijiroku_repo
      @authenticator = authenticator
    end

    def call(params)
      if params.valid?
        gijiroku = @gijiroku_repo.find_latest
        @gijiroku_repo.update(gijiroku.id, body: params[:content])
        self.body = "{\"response_code\":200,\"message\":\"OK\",\"response_body\":{\"id\":\"#{gijiroku.id}\"}}"
        self.format = :json
      else
        self.body = '{"response_code":422,"message":"Unprocessable Entity"}'
        self.format = :json
        self.status = 422
      end
    end
  end
end
