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
        @article = @article_repo.find_with_relations(params[:id])
        if @article.author.locked?  && @article.author.lock_key == cookies[:article_lock_key]
          @meetings = @meeting_repo.in_time
          @categories = @category_repo.all
        else
          redirect_to routes.new_meeting_article_lock_path(meeting_id: params[:meeting_id], article_id: @article.id)
        end
      end
    end
  end
end
