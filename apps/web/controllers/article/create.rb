module Web::Controllers::Article
  class Create
    include Web::Action
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
                   category_repo: CategoryRepository.new,
                   article_repo: ArticleRepository.new,
                   author_repo: AuthorRepository.new,
                   article_category_repo: ArticleCategoryRepository.new)

      @meeting_repo = meeting_repo
      @category_repo = category_repo
      @article_repo = article_repo
      @author_repo = author_repo
      @article_category_repo = article_category_repo
    end

    def call(params)
      if params.valid?
        author = @author_repo.create_with_plain_password(
          params[:article][:author][:name],
          params[:article][:author][:password]
        )
        article_params = params[:article].to_h.merge(author_id: author.id)
        article = @article_repo.create(article_params)
        @article_category_repo.attach_categories(article.id, params[:article][:categories])

        redirect_to routes.article_path(id: article.id)
      else
        @meetings = @meeting_repo.in_time
        @categories = @category_repo.all

        self.status = 422
      end
    end
  end
end
