module Admin::Controllers::History
  class Show
    include Admin::Action
    expose :history

    params do
      required(:id).filled(:int?)
    end

    def initialize(admin_history_repo: AdminHistoryRepository.new)
      @admin_history_repo = admin_history_repo
    end

    def call(params)
      halt 404 unless params.valid?

      @history = @admin_history_repo.find(params[:id])
      halt 404 unless @history
    end
  end
end
