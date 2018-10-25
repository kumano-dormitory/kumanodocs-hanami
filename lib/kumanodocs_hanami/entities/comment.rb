class Comment < Hanami::Entity
  def self.crypt(password)
    Digest::SHA256.hexdigest(password)
  end

  def authenticate(password)
    self.crypt_password == self.class.crypt(password)
  end
end
