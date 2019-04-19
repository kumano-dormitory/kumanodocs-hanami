class UserRepository < Hanami::Repository
  def find_by_name(name)
    users.where(name: name).map_to(User).one
  end
end
