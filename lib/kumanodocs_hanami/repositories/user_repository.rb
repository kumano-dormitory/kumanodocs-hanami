class UserRepository < Hanami::Repository
  def find_by_name(name)
    users.where(name: name).map_to(User).one
  end

  def by_authority(authority)
    users.where(authority: authority).to_a
  end
end
