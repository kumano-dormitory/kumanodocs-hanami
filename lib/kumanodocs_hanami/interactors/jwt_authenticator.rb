require 'hanami/interactor'

class JwtAuthenticator
  include Hanami::Interactor
  expose :verification

  def initialize(user: :all)
    @user = user
  end

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
    # tokenのバージョンを確認
    return false unless decoded_token[0]['version'] == ENV['KUMANODOCS_AUTH_TOKEN_VERSION']
    # tokenのuserを確認
    if @user != :all
      return false unless decoded_token[0]['id'] == @user
    end

    true
  end
end
