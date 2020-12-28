# ====
# 寮生大会議事録の更新アクション
# ====
# 寮生大会議事録を更新する

module Super::Controllers::Gijiroku
  class Update
    include Super::Action
    expose :gijiroku

    params do
      required(:id).filled(:int?)
      required(:gijiroku).schema do
        optional(:description).maybe(:str?)
        required(:body).filled(:str?)
      end
    end

    def initialize(gijiroku_repo: GijirokuRepository.new)
      @gijiroku_repo = gijiroku_repo
    end

    def call(params)
      @gijiroku = @gijiroku_repo.find(params[:id])
      if params.valid?
        @gijiroku_repo.update(@gijiroku.id, params[:gijiroku])
        redirect_to routes.gijiroku_path(id: @gijiroku.id)
      end
    end
  end
end
