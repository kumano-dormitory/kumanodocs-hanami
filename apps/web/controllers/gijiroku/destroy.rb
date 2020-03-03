# ====
# 寮生大会議事録の削除アクション
# ====
# 寮生大会議事録を削除する

module Web::Controllers::Gijiroku
  class Destroy
    include Web::Action

    def initialize(gijiroku_repo: GijirokuRepository.new,
                   authenticator: JwtAuthenticator.new)
      @gijiroku_repo = gijiroku_repo
      @authenticator = authenticator
    end

    def call(params)
      gijiroku = @gijiroku_repo.find(params[:id])
      @gijiroku_repo.delete(gijiroku.id)
      redirect_to routes.gijirokus_path
    end
  end
end
