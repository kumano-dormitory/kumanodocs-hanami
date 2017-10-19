module Admin::Controllers::Meeting
  module Article
    class Show
      include Admin::Action
      expose :article
      expose :meeting

      def initialize(article_repo: ArticleRepository.new,
                     meeting_repo: MeetingRepository.new)
        @article_repo = article_repo
      end

      def call(params)
        @article = @article_repo.find_with_relations(params[:id])
      end
    end
  end
end
