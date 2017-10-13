module Admin::Controllers::Meeting
  module Article
    class Update
      include Admin::Action
      expose :meetings, :categories, :confirm_update

      params do
        required(:article).schema do
          required(:meeting_id).filled(:int?)
          required(:categories) { array? { min_size?(1) & each { int? } } }
          required(:title).filled(:str?)
          required(:author).schema do
            required(:name).filled(:str?)
          end
          required(:body).filled(:str?)
          required(:get_lock).filled(:bool?)
        end
      end

      def initialize(meeting_repo: MeetingRepository.new,
                     article_repo: ArticleRepository.new,
                     category_repo: CategoryRepository.new,
                     author_repo: AuthorRepository.new)
        @meeting_repo = meeting_repo
        @article_repo = article_repo
        @category_repo = category_repo
        @author_repo = author_repo
      end

      def call(params)
        if params.valid?
          article = @article_repo.find_with_relations(params[:id])
          if article.author.lock_key == cookies[:article_lock_key] || params[:article][:get_lock]
            category_params = params[:article][:categories].map { |category_id| {category_id: category_id} }
            @article_repo.update_categories(article, category_params)
            @author_repo.update(article.author_id, params[:article][:author])
            @article_repo.update(article.id, params[:article])
            @author_repo.release_lock(article.author_id)
            redirect_to routes.meeting_article_path(meeting_id: article.meeting_id, id: article.id)
          else
            @confirm_update = true
          end
        else
          self.status = 422
        end
        @meetings = @meeting_repo.in_time
        @categories = @category_repo.all
      end
    end
  end
end
