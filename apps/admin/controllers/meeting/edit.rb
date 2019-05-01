module Admin::Controllers::Meeting
  class Edit
    include Admin::Action
    expose :meeting

    def initialize(meeting_repo: MeetingRepository.new)
      @meeting_repo = meeting_repo
    end

    def call(params)
      @meeting = @meeting_repo.find(params[:id])
    end
  end
end
