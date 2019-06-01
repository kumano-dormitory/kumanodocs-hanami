module Api::Controllers::Login
  class Token
    include Api::Action

    params do
      required(:username).filled(:str?)
      required(:password).filled(:str?)
    end

    def initialize(user_repo: UserRepository.new)
      @user_repo = user_repo
    end

    def call(params)
      error_response = '{"response_code":403,"message":"Forbidden"}'
      if params.valid?
        user = @user_repo.find_by_name(params[:username])
        if !user.nil? && user.authority == 0 && user.authenticate(params[:password])
          token = generate_token(user.name, ENV['KUMANODOCS_AUTH_TOKEN_VERSION'])
          self.body = "{\"response_code\":200,\"message\":\"OK\",\"response_body\":{\"token\":\"#{token}\"}}"
          self.format = :json
        else
          self.body = error_response
          self.format = :json
        end
      else
        self.body = error_response
        self.format = :json
      end
    end

    def generate_token(name, version, exp_day = 180)
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
