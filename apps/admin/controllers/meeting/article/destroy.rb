module Admin::Controllers::Meeting
  module Article
    class Destroy
      include Admin::Action

      def initialize(article_repo: ArticleRepository.new)
        @article_repo = article_repo
      end

      def call(params)
        @article_repo.delete(params[:id])
        redirect_to routes.meeting_articles_path(meeting_id: params[:meeting_id])
      end
    end
  end
end
