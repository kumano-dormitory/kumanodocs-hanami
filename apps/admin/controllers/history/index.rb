module Admin::Controllers::History
  class Index
    include Admin::Action
    expose :histories, :page

    HISTORY_COUNT_LIMIT = 25

    def initialize(admin_history_repo: AdminHistoryRepository.new,
                   authenticator: AdminAuthenticator.new)
      @admin_history_repo = admin_history_repo
      @authenticator = authenticator
    end

    def call(params)
      @page = params[:page] ? params[:page].to_i : 1
      @page = 1 if page <= 0

      @histories = @admin_history_repo.desc_by_created_at(limit: HISTORY_COUNT_LIMIT, offset: HISTORY_COUNT_LIMIT * (@page - 1))
    end
  end
end
