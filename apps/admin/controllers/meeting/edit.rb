module Admin::Controllers::Meeting
  class Edit
    include Admin::Action
    expose :meeting

    def initialize(meeting_repo: MeetingRepository.new,
                   authenticator: AdminAuthenticator.new)
      @meeting_repo = meeting_repo
      @authenticator = authenticator
    end

    def call(params)
      @meeting = @meeting_repo.find(params[:id])
    end
  end
end
