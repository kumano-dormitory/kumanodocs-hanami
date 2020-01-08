# ====
# へんなアクション
# ====
# へんなページを表示する
# 特に意味はない

module Web::Controllers::Funny
  class About
    include Web::Action

    def initialize(authenticator: JwtAuthenticator.new)
      @authenticator = authenticator
    end

    def call(params)
    end
  end
end
