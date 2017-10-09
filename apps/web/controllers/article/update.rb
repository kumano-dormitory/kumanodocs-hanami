module Web::Controllers::Article
  class Update
    include Web::Action
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
      end

    end

    def initialize(article_repo: ArticleRepository.new,
                   author_repo: AuthorRepository.new,
                   meeting_repo: MeetingRepository.new,
                   category_repo: CategoryRepository.new)
      @article_repo = article_repo
      @author_repo = author_repo
      @meeting_repo = meeting_repo
      @category_repo = category_repo
    end

    def call(params)
      if params.valid?
        article = @article_repo.find(params[:id])
        category_datas = params[:article][:categories].map { |category_id| { category_id: category_id } }
        @article_repo.update_categories(article, category_datas)
        @author_repo.update(article.author_id, params[:article][:author])
        @article_repo.update(article.id, params[:article])
        redirect_to routes.article_path(id: params[:id])
      else
        @meetings = @meeting_repo.in_time
        @categories = @category_repo.all

        self.status = 422
      end
    end
  end
end
