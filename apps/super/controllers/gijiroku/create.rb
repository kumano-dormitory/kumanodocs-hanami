# ====
# 寮生大会議事録の新規作成アクション
# ====
# 寮生大会議事録を新規作成する

module Super::Controllers::Gijiroku
  class Create
    include Super::Action

    params do
      required(:gijiroku).schema do
        optional(:description).maybe(:str?)
        required(:body).filled(:str?)
      end
    end

    def initialize(gijiroku_repo: GijirokuRepository.new)
      @gijiroku_repo = gijiroku_repo
    end

    def call(params)
      if params.valid?
        gijiroku = @gijiroku_repo.create(params[:gijiroku])
        redirect_to routes.gijiroku_path(id: gijiroku.id)
      end
    end
  end
end
