# ====
# 寮生大会議事録の編集ページ表示アクション
# ====
# 寮生大会議事録を編集するページを表示する

module Super::Controllers::Gijiroku
  class Edit
    include Super::Action
    expose :gijiroku

    def initialize(gijiroku_repo: GijirokuRepository.new)
      @gijiroku_repo = gijiroku_repo
    end

    def call(params)
      @gijiroku = @gijiroku_repo.find(params[:id])
    end
  end
end
