module Web::Controllers::Meeting
  class Index
    include Web::Action
    expose :meetings

    def initialize(meeting_repository: MeetingRepository.new)
      @meeting_repository = meeting_repository
    end

    def call(params)
      @meetings = @meeting_repository.for_articles
    end
  end
end
