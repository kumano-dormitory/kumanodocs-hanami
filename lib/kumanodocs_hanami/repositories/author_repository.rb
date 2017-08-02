require 'digest'

class AuthorRepository < Hanami::Repository
  def create_with_plain_password(name, password)
    crypt_password = Digest::SHA256.hexdigest(password)
    create(name: name, crypt_password: crypt_password)
  end
end
