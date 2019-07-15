require 'hanami/interactor'

class JwtAuthenticator
  include Hanami::Interactor
  expose :verification

  def call(token)
    @verification = authenticate(token)
  end

  def authenticate(token)
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
