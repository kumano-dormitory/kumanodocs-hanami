require 'digest'

class AuthorRepository < Hanami::Repository
  def create_with_plain_password(name, password)
    crypt_password = Author.crypt(password)
    create(name: name, crypt_password: crypt_password)
  end

  def lock(id, password)
    lock_key = Author.generate_lock_key
    update(id, lock_key: lock_key)
    lock_key
  end
end
