module Admin::Controllers::ArticleStatus
  class Edit
    include Admin::Action
    expose :meeting

    def initialize(meeting_repo: MeetingRepository.new,
                   authenticator: AdminAuthenticator.new)
      @meeting_repo = meeting_repo
      @authenticator = authenticator
    end

    def call(params)
      @meeting = @meeting_repo.find_with_articles(params[:id])
    end
  end
end
