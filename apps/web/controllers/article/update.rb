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
        optional(:vote_content).maybe(:str?)
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
      @notifications = {}
    end

    def call(params)
      if params.valid?
        article = @article_repo.find_with_relations(params[:id])
        if article.author.lock_key == cookies[:article_lock_key]
          # ログインが有効なので編集可
          update(article, params)
        else
          if params[:article][:get_lock]
            if article.author.authenticate(params[:article][:password])
              # 認証が成功したので編集可
              update(article, params)
            else
              @confirm_update = true
              @notifications = {error: {status: "Authentication Failed", message: "パスワードが不正です. 正しいパスワードを入力してください"}}
              self.status = 401
            end
          else
            @confirm_update = true
          end
        end
      else
        self.status = 422
        @notifications = {error: {status: "Error:", message: "入力された項目に不備があり保存できません. もう一度確認してください"}}
      end
      @meetings = @meeting_repo.in_time
      @categories = @category_repo.all
    end

    private
    def update(article, params)
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
      flash[:notifications] = {success: {status: "Success:", message: "正常に議案が編集されました"}}
      redirect_to routes.article_path(id: article.id)
    end

    def notifications
      @notifications
    end
  end
end
