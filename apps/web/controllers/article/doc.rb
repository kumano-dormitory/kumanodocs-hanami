# ====
# 資料システムの利用方法表示アクション
# ====
# 資料システムの利用方法を表示する
# タイプ（全般・議案の投稿方法・編集方法・表の追加方法など）をパラメータで指定

module Web
  module Controllers
    module Article
      class Doc
        include Web::Action
        expose :type

        params do
          optional(:type) { filled? & int? & gteq?(0) & lteq?(3) }
        end

        # Dependency injection
        # authenticatorは認証モジュールで必須(../authentication.rb)
        def initialize(authenticator: JwtAuthenticator.new)
          @authenticator = authenticator
        end

        def call(params)
          # typeは 0: 利用方法, 1: 議案の投稿方法, 2: 議案の編集方法, 3: 表の追加方法
          if params.valid?
            @type = params[:type] || 0
          else
            @type = 0
          end
        end

        def navigation
          @navigation = {bottom_navigation: true, enable_dark: true}
        end
      end
    end
  end
end
