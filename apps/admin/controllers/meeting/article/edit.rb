module Admin::Controllers::Meeting
  module Article
    class Edit
      include Admin::Action

      def initialize(article_repo: ArticleRepository.new,
                     meeting_repo: MeetingRepository.new,
                     category_repo: CategoryRepository.new)
        @article_repo = article_repo
        @meeting_repo = meeting_repo
        @category_repo = category_repo
      end

      def call(params)
      end
    end
  end
end
