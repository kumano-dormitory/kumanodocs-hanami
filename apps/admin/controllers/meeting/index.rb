module Admin::Controllers::Meeting
  class Index
    include Admin::Action
    expose :meetings, :page

    MEETING_COUNT_LIMIT = 15

    params do
      optional(:page) { filled? & int? & gt?(0) }
    end

    def initialize(meeting_repo: MeetingRepository.new,
                   authenticator: AdminAuthenticator.new)
      @meeting_repo = meeting_repo
      @authenticator = authenticator
    end

    def call(params)
      if params.valid?
        @page = params[:page] || 1
      else
        @page = 1
      end
      @meetings = @meeting_repo.desc_by_date(limit: MEETING_COUNT_LIMIT, offset: MEETING_COUNT_LIMIT * (@page - 1))
    end

    def navigation
      @navigation = {meeting: true}
    end
  end
end
