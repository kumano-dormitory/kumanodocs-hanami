# ====
# 寮生大会議事録の新規作成ページ表示アクション
# ====
# 寮生大会議事録を新規作成するページを表示する

module Web::Controllers::Gijiroku
  class New
    include Web::Action

    def initialize(authenticator: JwtAuthenticator.new)
      @authenticator = authenticator
    end

    def call(params)
    end
  end
end
