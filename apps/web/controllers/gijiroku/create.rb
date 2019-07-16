module Web::Controllers::Gijiroku
  class Create
    include Web::Action

    params do
      required(:gijiroku).schema do
        required(:body).filled(:str?)
      end
    end

    def initialize(gijiroku_repo: GijirokuRepository.new,
                   authenticator: JwtAuthenticator.new)
      @gijiroku_repo = gijiroku_repo
      @authenticator = authenticator
    end

    def call(params)
      if params.valid?
        gijiroku = @gijiroku_repo.create(params[:gijiroku])
        redirect_to routes.gijiroku_path(id: gijiroku.id)
      end
    end
  end
end
