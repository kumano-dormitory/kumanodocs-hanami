require 'securerandom'

class Author < Hanami::Entity
  def self.crypt(password)
    Digest::SHA256.hexdigest(password)
  end

  def self.generate_lock_key
    SecureRandom.hex(20)
  end

  def authenticate(password)
    self.crypt_password == self.class.crypt(password)
  end

  def locked?
    !lock_key.nil?
  end
end
