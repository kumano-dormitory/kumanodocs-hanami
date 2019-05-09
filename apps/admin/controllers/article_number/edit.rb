module Admin::Controllers::ArticleNumber
  class Edit
    include Admin::Action
    expose :meeting, :for_download

    def initialize(meeting_repo: MeetingRepository.new)
      @meeting_repo = meeting_repo
    end

    def call(params)
      @meeting = @meeting_repo.find_with_articles(params[:id])
      @for_download = params[:download] || false
    end

    def navigation
      @navigation = {pdf: @for_download}
    end
  end
end
