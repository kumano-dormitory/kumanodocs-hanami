module Admin::Controllers::Meeting
  module Article
    class Edit
      include Admin::Action
      expose :meetings, :categories, :article

      def initialize(article_repo: ArticleRepository.new,
                     meeting_repo: MeetingRepository.new,
                     category_repo: CategoryRepository.new)
        @article_repo = article_repo
        @meeting_repo = meeting_repo
        @category_repo = category_repo
      end

      def call(params)
        @meetings = @meeting_repo.desc_by_date
        @categories = @category_repo.all
        @article = @article_repo.find_with_relations(params[:id])
      end
    end
  end
end
