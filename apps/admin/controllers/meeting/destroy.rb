module Admin::Controllers::Meeting
  class Destroy
    include Admin::Action

    def initialize(meeting_repo: MeetingRepository.new)
      @meeting_repo = meeting_repo
    end

    def call(params)
      @meeting_repo.delete(params[:id])
      redirect_to routes.meetings_path
    end
  end
end
