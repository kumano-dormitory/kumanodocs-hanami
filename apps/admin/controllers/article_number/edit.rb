module Admin::Controllers::ArticleNumber
  class Edit
    include Admin::Action
    expose :meeting

    def initialize(meeting_repo: MeetingRepository.new)
      @meeting_repo = meeting_repo
    end

    def call(params)
      @meeting = @meeting_repo.find_with_articles(params[:id])
    end
  end
end
