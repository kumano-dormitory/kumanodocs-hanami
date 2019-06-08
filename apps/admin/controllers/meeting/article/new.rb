module Admin::Controllers::Meeting
  module Article
    class New
      include Admin::Action
      expose :meeting, :categories, :recent_articles

      def initialize(meeting_repo: MeetingRepository.new,
                     article_repo: ArticleRepository.new,
                     category_repo: CategoryRepository.new)
        @meeting_repo = meeting_repo
        @article_repo = article_repo
        @category_repo = category_repo
      end

      def call(params)
        @meeting = @meeting_repo.find(params[:meeting_id])
        @categories = @category_repo.all
        @recent_articles = @article_repo.of_recent(months: 6, past_meeting_only: false, with_relations: true)
      end
    end
  end
end
