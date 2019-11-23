# ====
# 議案の更新アクション
# ====
# 議案の編集ページからのリクエストを処理し、議案の変更をDBに保存
# パラメータが不適切な場合などのエラー時には、もう一度編集ページを表示
# 複数人が同時に編集を行っている場合には警告を含めた編集ページを表示
# = 主な処理
# - 議案のパラメータをチェック（必須項目が埋められているか）
# - ブロック会議の投稿締め切りをチェックし、更新が可能かを決定
# - 変更をデータベースに保存

module Web::Controllers::Article
  class Update
    include Web::Action
    expose :meetings, :categories, :confirm_update, :recent_articles, :article_refs_selected

    params do
      required(:id).filled(:int?)
      required(:article).schema do
        required(:meeting_id).filled(:int?)
        required(:categories) { array? { min_size?(1) & each { int? } } }
        required(:title).filled(:str?)
        required(:author).schema do
          required(:name).filled(:str?)
        end
        required(:format).filled(:bool?)
        required(:body).filled(:str?)
        optional(:vote_content).maybe(:str?)
        optional(:same_refs_selected) { array? { each { int? } } }
        optional(:other_refs_selected) { array? { each { int? } } }
        required(:get_lock).filled(:bool?)
        optional(:password).filled(:str?)
      end
    end

    def initialize(article_repo: ArticleRepository.new,
                   author_repo: AuthorRepository.new,
                   meeting_repo: MeetingRepository.new,
                   category_repo: CategoryRepository.new,
                   article_reference_repo: ArticleReferenceRepository.new,
                   authenticator: JwtAuthenticator.new)
      @article_repo = article_repo
      @author_repo = author_repo
      @meeting_repo = meeting_repo
      @category_repo = category_repo
      @article_reference_repo = article_reference_repo
      @authenticator = authenticator
      @notifications = {}
    end

    def call(params)
      if params.valid?
        article = @article_repo.find_with_relations(params[:id])
        if article.author.lock_key == cookies[:article_lock_key]
          # ログインが有効なので編集可
          update_if_editable(article, params)
        else
          if params[:article][:get_lock]
            if article.author.authenticate(params[:article][:password])
              # 認証が成功したので編集可
              update_if_editable(article, params)
            else
              @confirm_update = true
              @meetings = @meeting_repo.in_time
              @notifications = {error: {status: "Authentication Failed", message: "パスワードが不正です. 正しいパスワードを入力してください"}}
              self.status = 401
            end
          else
            @confirm_update = true
            @meetings = @meeting_repo.in_time
          end
        end
      else
        @meetings = @meeting_repo.in_time
        @notifications = {error: {status: "Error:", message: "入力された項目に不備があり保存できません. もう一度確認してください"}}
        self.status = 422
      end
      @categories = @category_repo.all
      @recent_articles = @article_repo.of_recent(months: 3, past_meeting_only: false, with_relations: true)
      @article_refs_selected = { same: params[:article][:same_refs_selected], other: params[:article][:other_refs_selected] }
    end

    private
    def update(article, params)
      categories = params[:article][:categories].map { |id| @category_repo.find(id) }
      # 採決項目の設定
      category_params = categories.map { |category|
        if category.require_content && (category.name == '採決' || category.name == '採決予定')
          { category_id: category.id, extra_content: params[:article][:vote_content] }
        else
          { category_id: category.id, extra_content: nil }
        end
      }
      article_params = params[:article].to_h.merge(
        format: (params[:article][:format] ? 1 : 0)
      )
      @article_repo.update_categories(article, category_params)
      @author_repo.update(article.author_id, params[:article][:author])
      @article_repo.update(article.id, article_params)
      @author_repo.release_lock(article.author_id)
      @article_reference_repo.update_refs(article.id, params[:article][:same_refs_selected], params[:article][:other_refs_selected])
      flash[:notifications] = {success: {status: "Success:", message: "正常に議案が編集されました"}}
      redirect_to routes.article_path(id: article.id)
    end

    def update_if_editable(article, params)
      if after_deadline?
        # 追加議案の編集期間
        if @meeting_repo.find_most_recent.id == article.meeting.id && !article.checked && !article.printed
          update(article, params)
        else
          @meetings = [@meeting_repo.find_most_recent]
          @notifications = {error: {status: "Error:", message: "議案が追加議案ではないか、追加議案であっても資料委員会が印刷済みのため編集できません. 編集したい場合は資料委員会に相談してください."}}
          self.status = 422
        end
      else
        # 通常の編集期間
        if article.meeting.deadline > Time.now
          update(article, params)
        else
          @meetings = @meeting_repo.in_time
          @notifications = {error: {status: "Error:", message: "ブロック会議の締め切りを過ぎているため議案を編集できません. 編集したい場合は資料委員会に相談してください."}}
          self.status = 422
        end
      end
    end

    def notifications
      @notifications
    end
  end
end
