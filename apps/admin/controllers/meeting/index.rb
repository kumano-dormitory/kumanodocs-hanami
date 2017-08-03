module Admin::Controllers::Meeting
  class Index
    include Admin::Action
    expose :meetings

    def initialize(meeting_repo: MeetingRepository.new)
      @meeting_repo = meeting_repo
    end

    def call(params)
      @meetings = @meeting_repo.order_by_date
    end
  end
end
