module Web::Controllers::Meeting
  class Index
    include Web::Action
    expose :meetings

    def initialize(meeting_repo: MeetingRepository.new)
      @meeting_repo = meeting_repo
    end

    def call(params)
      @meetings = @meeting_repo.desc_by_date
    end
  end
end