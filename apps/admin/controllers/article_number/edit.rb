module Admin::Controllers::ArticleNumber
  class Edit
    include Admin::Action
    expose :meeting
    expose :articles

    def initialize(meeting_repo: MeetingRepository.new,
                   article_repo: ArticleRepository.new)
      @meeting_repo = meeting_repo
      @article_repo = article_repo
    end

    def call(params)
      @meeting = @meeting_repo.find(params[:id])
      @articles = @article_repo.by_meeting(params[:id])
    end
  end
end
