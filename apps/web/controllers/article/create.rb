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
        optional(:vote_content).maybe(:str?)
      end
    end

    def initialize(meeting_repo: MeetingRepository.new,
                   category_repo: CategoryRepository.new,
                   article_repo: ArticleRepository.new,
                   author_repo: AuthorRepository.new)
      @meeting_repo = meeting_repo
      @category_repo = category_repo
      @article_repo = article_repo
      @author_repo = author_repo
      @notifications = {}
    end

    def call(params)
      if params.valid?
        author = @author_repo.create_with_plain_password(
          params[:article][:author][:name],
          params[:article][:author][:password]
        )
        article_params = params[:article].to_h.merge(author_id: author.id)
        article = @article_repo.create(article_params)
        categories = params[:article][:categories].map { |id| @category_repo.find(id) }
        # 採決項目の設定
        category_params = categories.map { |category|
          if category.require_content && category.name == '採決'
            { category_id: category.id, extra_content: params[:article][:vote_content] }
          else
            { category_id: category.id, extra_content: nil }
          end
        }
        @article_repo.add_categories(article, category_params)
        flash[:notifications] = {success: {status: "Success", message: "正常に議案が投稿されました"}}
        redirect_to routes.article_path(id: article.id)
      else
        @meetings = @meeting_repo.in_time
        @categories = @category_repo.all
        @notifications = {error: {status: "Error:", message: "入力された項目に不備があり投稿できません. もう一度確認してください"}}
        self.status = 422
      end
    end

    def navigation
      @navigation = {new_article: true}
    end

    def notifications
      @notifications
    end
  end
end
