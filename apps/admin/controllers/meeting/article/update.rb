module Admin::Controllers::Meeting
  module Article
    class Update
      include Admin::Action
      expose :meetings, :categories

      params do
        required(:article).schema do
          required(:meeting_id).filled(:int?)
          required(:categories) { array? { min_size?(1) & each { int? } } }
          required(:title).filled(:str?)
          required(:author).schema do
            required(:name).filled(:str?)
          end
          required(:body).filled(:str?)
          optional(:vote_content).filled(:str?)
        end
        required(:id).filled(:int?)
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
          article = @article_repo.find(params[:id])

          categories = params[:article][:categories].map { |id| @category_repo.find(id) }
          # 採決項目の設定
          category_params = categories.map { |category|
            if category.require_content && category.name == '採決'
              { category_id: category.id, extra_content: params[:article][:vote_content] }
            else
              { category_id: category.id, extra_content: nil }
            end
          }
          @article_repo.update_categories(article, category_params)
          @author_repo.update(article.author_id, params[:article][:author])
          @article_repo.update(article.id, params[:article])
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
