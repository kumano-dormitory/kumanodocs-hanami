module Api
  module Authentication
    def self.included(action)
      action.class_eval do
        before :authenticate!
      end
    end

    private

    def authenticate!
      halt 403 unless authenticated?
    end

    def authenticated?
      token = params[:token]
      return false unless token

      rsa_private = OpenSSL::PKey::RSA.new(KUMANODOCS_AUTH_TOKEN_PKEY)
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
