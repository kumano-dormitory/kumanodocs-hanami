# ====
# 寮生大会議事録の本文取得アクション
# ====
# 寮生大会議事録の自動更新において、このアクションから本文を取得し更新する
# レスポンスはテキスト形式で議事録の本文のみである

module Web::Controllers::Gijiroku
  class Content
    include Web::Action

    def initialize(json_repo: JsonRepository.new,
                   authenticator: JwtAuthenticator.new)
      @json_repo = json_repo
      @authenticator = authenticator
    end

    def call(params)
      gijiroku = @json_repo.latest_gijiroku
      self.body = gijiroku[:body]&.gsub(/(\r\n|\r|\n)/,'<br>') || ''
      self.format = :txt
    end
  end
end
