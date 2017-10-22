module Admin::Controllers::Meeting
  module Article
    class Create
      include Admin::Action
      expose :meetings, :categories

      params do
        required(:article).schema do
          required(:meeting_id).filled(:int?)
          required(:categories) { array? { min_size?(1) & each { int? } } }
          required(:title).filled(:str?)
          required(:author).schema do
            required(:name).filled(:str?)
            required(:password).filled(:str?).confirmation
            required(:password_confirmation).filled(:str?)
          end
          required(:body).filled(:str?)
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
          author_params = params[:article][:author]
          category_params = params[:article][:categories].map { |category_id| { category_id: category_id } }
          article_params = params[:article]
          article = @article_repo.create_with_related_entities(author_params, category_params, article_params)

          redirect_to routes.meeting_article_path(meeting_id: article.meeting_id, id: article.id)
        else
          @meetings = @meeting_repo.in_time
          @categories = @category_repo.all

          self.status = 422
        end
      end
    end
  end
end
