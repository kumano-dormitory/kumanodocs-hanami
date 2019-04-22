module Web::Controllers::Meeting
  class Show
    include Web::Action
    expose :meeting, :page, :max_page, :article_limit

    def initialize(meeting_repo: MeetingRepository.new, article_limit: 10)
      @meeting_repo = meeting_repo
      @article_limit = article_limit
    end

    def call(params)
      @page = params[:page]&.to_i || 1
      @meeting = @meeting_repo.find_with_articles(params[:id])
      @max_page = (meeting.articles.length - 1) / @article_limit + 1
    end

    def navigation
      @navigation = {meeting: true}
    end
  end
end
