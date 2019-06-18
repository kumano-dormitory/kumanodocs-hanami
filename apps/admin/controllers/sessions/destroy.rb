module Admin::Controllers::Sessions
  class Destroy
    include Admin::Action

    def initialize(admin_history_repo: AdminHistoryRepository.new)
      @admin_history_repo = admin_history_repo
    end

    def call(params)
      user_id = session[:user_id]
      session[:user_id] = nil
      @admin_history_repo.add(:sessions_destroy, JSON.pretty_generate({action:"sessions_destroy", payload:{user_id: user_id}}))
      redirect_to '/'
    end
  end
end
