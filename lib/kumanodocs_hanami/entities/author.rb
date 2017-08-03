class Author < Hanami::Entity
  def self.crypt(password)
    Digest::SHA256.hexdigest(password)
  end

end
