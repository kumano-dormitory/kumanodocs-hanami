# ====
# 寮生大会議事録の一覧表示アクション
# ====
# 過去の寮生大会議事録も含めて一覧を表示する

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
