module Web::Controllers::Article
  class Update
    include Web::Action
    expose :meetings, :categories, :confirm_update

    params do
      required(:id).filled(:int?)
      required(:article).schema do
        required(:meeting_id).filled(:int?)
        required(:categories) { array? { min_size?(1) & each { int? } } }
        required(:title).filled(:str?)
        required(:author).schema do
          required(:name).filled(:str?)
        end
        required(:body).filled(:str?)
        optional(:vote_content).filled(:str?)
        required(:get_lock).filled(:bool?)
        optional(:password).filled(:str?)
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
        article = @article_repo.find_with_relations(params[:id])
        if article.author.lock_key == cookies[:article_lock_key] \
            || (params[:article][:get_lock] && article.author.authenticate(params[:article][:password]))

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
          @author_repo.release_lock(article.author_id)
          redirect_to routes.article_path(id: article.id)
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
