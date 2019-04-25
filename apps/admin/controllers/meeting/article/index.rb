module Admin::Controllers::Meeting
  module Article
    class Index
      include Admin::Action
      expose :meeting, :articles

      def initialize(article_repo: ArticleRepository.new,
                     meeting_repo: MeetingRepository.new)
        @article_repo = article_repo
        @meeting_repo = meeting_repo
      end

      def call(params)
        @meeting = @meeting_repo.find(params[:meeting_id])
        @articles = @article_repo.by_meeting(params[:meeting_id])
      end
    end
  end
end
