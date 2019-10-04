require 'hanami/interactor'

class AdminAuthenticator
  include Hanami::Interactor

  expose :user

  def initialize(user_repo: UserRepository.new)
    @user_repo = user_repo
  end

  def call(user_id)
    @user = @user_repo.find(user_id)
  end
end
