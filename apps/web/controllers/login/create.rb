# ====
# 資料システムへのログインアクション
# ====
# 資料システムへのログインを行う
# ユーザー名とパスワードで認証を行い、有効なJWTを発行する

require 'jwt'

module Web::Controllers::Login
  class Create
    include Web::Action
    expose :standalone, :path

    params do
      required(:login).schema do
        required(:username).filled(:str?)
        required(:password).filled(:str?)
      end
      optional(:standalone).filled(:bool?)
      optional(:path).filled(:str?)
    end

    def initialize(user_repo: UserRepository.new)
      @user_repo = user_repo
    end

    def call(params)
      @standalone = !!params[:standalone]
      @path = params[:path]
      if params.valid?
        user = @user_repo.find_by_name(params[:login][:username])
        if !user.nil? && user.authority == 0 && user.authenticate(params[:login][:password])
          session.clear # sessionキーの変更
          if @standalone
            # standalone(PWAの場合)である場合には通常より長い期間(180日)ログインが有効となるトークンを渡す
            cookies[:token] = {
              value: generate_token(user.name, ENV['KUMANODOCS_AUTH_TOKEN_VERSION'], 180),
              path: '/',
              httponly: false,
              max_age: (3600 * 24 * 180)
            }
            redirect_to routes.root_path + '?loggedin=true'
          else
            # 通常のウェブブラウザなどからのログイン時は7日間有効なトークンを渡す
            cookies[:token] = {
              value: generate_token(user.name, ENV['KUMANODOCS_AUTH_TOKEN_VERSION']),
              path: '/',
              httponly: true
            }
            if params[:path]
              decoded_path = Base64.urlsafe_decode64(params[:path])
              redirect_to decoded_path
            else
              redirect_to routes.root_path
            end
          end
        end
      end
      cookies[:token] = nil
    end

    # 有効なJWTを作成する関数
    def generate_token(name, version, exp_day = 7)
      rsa_private = OpenSSL::PKey::RSA.new(KUMANODOCS_AUTH_TOKEN_PKEY)
      exp = Time.now.to_i + (exp_day * 24 * 3600)
      payload = {
        id: name,
        version: version,
        exp: exp
      }
      JWT.encode(payload, rsa_private, 'RS256')
    end

    def authenticate!
      # do nothing
    end
  end
end
