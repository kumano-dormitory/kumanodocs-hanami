require 'bcrypt'

class User < Hanami::Entity
  def self.crypt(password)
    BCrypt::Password.create(password)
  end

  def authenticate(password)
    stored_password = BCrypt::Password.new(self.crypt_password)
    stored_password == password
  end
end
