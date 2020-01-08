# ====
# 資料システムへのログイン画面表示アクション
# ====
# 資料システムにログインする画面を表示する
# 未ログイン時にはトップページがこのページとなる

module Web::Controllers::Login
  class Show
    include Web::Action
    expose :standalone, :invalid_token

    def initialize(authenticator: JwtAuthenticator.new)
      @authenticator = authenticator
    end

    def call(params)
      @standalone = !!params[:standalone]
      @invalid_token = !!params[:invalid]
      if @standalone && authenticated?
        redirect_to routes.root_path
      end
    end

    def authenticate!
      # do nothing
    end
  end
end
