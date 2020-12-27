# =====
# Authenticate module for Web app actions (一般向けページ)
# =====
# 一般向けページに共通する認証を提供するモジュール
# 認証の具体的実装は、 authenticatorで隠蔽
# authenticatorは各actionの初期化時に指定
# 現状はすべてjwt_authenticator (lib/kumanodocs_hanami/interactors/jwt_authenticator.rb)

module Web
  module Authentication
    def self.included(action)
      action.class_eval do
        before :authenticate!
      end
    end

    private

    def authenticate!
      if params[:standalone]
        # PWAでのリダイレクトの場合はlocalstorageからtokenを削除する
        redirect_to (routes.login_path + '?standalone=true&invalid=true') unless authenticated?
      else
        unless authenticated?
          if params.env['REQUEST_URI'] == '/' || params.env['REQUEST_URI'] == ''
            # トップページへのアクセスの場合
            redirect_to routes.login_path
          else
            # その他のページへのアクセスの場合
            # リクエスト先のパスの情報を含めてリダイレクト
            encoded_path = Base64.urlsafe_encode64(params.env['REQUEST_URI'].slice(0, 250))
            redirect_to (routes.login_path + "?path=#{encoded_path}")
          end
        end
      end
    end

    def authenticated?
      # authenticatorを呼び出し、認証が成功したかを判定
      !!(@authenticator&.call(cookies[:token]).verification)
    end
  end
end
