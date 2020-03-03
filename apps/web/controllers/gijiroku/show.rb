# ====
# 寮生大会議事録の表示アクション
# ====
# 指定された寮生大会議事録を表示する
# 基本的に寮生大会議事録一覧ページから遷移してくる
# 議事録本文に加えて、更新日時なども表示する

module Web::Controllers::Gijiroku
  class Show
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
