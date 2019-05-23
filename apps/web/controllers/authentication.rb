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
        redirect_to routes.login_path unless authenticated?
      end
    end

    def authenticated?
      token = cookies[:token]
      return false unless token

      rsa_private = OpenSSL::PKey::RSA.new(ENV['KUMANODOCS_AUTH_TOKEN_PKEY'])
      rsa_public = rsa_private.public_key
      begin
        decoded_token = JWT.decode(token, rsa_public, true, { algorithm: 'RS256' } )
      rescue => e
        p e.message
        return false
      end
      decoded_token[0]['version'] == ENV['KUMANODOCS_AUTH_TOKEN_VERSION']
    end
  end
end
