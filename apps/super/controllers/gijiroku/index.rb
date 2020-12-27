# ====
# 寮生大会議事録の一覧表示アクション
# ====
# 過去の寮生大会議事録も含めて一覧を表示する

module Super::Controllers::Gijiroku
  class Index
    include Super::Action
    expose :gijirokus

    def initialize(gijiroku_repo: GijirokuRepository.new)
      @gijiroku_repo = gijiroku_repo
    end

    def call(params)
      @gijirokus = @gijiroku_repo.desc_by_created_at
    end
  end
end
