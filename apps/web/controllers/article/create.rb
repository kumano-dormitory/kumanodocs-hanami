# ====
# 議案の新規投稿アクション
# ====
# 議案の投稿ページからのリクエストを処理し、新規議案をDBに保存
# パラメータが不適切な場合などのエラー時には、もう一度投稿ページを表示
# = 主な処理
# - 議案のパラメータをチェック（必須項目が埋められているか、適切なブロック会議が指定されているか）
# - ブロック会議の投稿締め切りをチェックし、現在時刻に応じて通常議案か追加議案化を決定
# - 議案をデータベースに保存

module Web::Controllers::Article
  class Create
    include Web::Action
    expose :meetings, :next_meeting, :categories, :recent_articles, :article_refs_selected

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
        required(:format).filled(:bool?)
        required(:body).filled(:str?)
        optional(:vote_content).maybe(:str?)
        optional(:same_refs_selected) { array? { each { int? } } }
        optional(:other_refs_selected) { array? { each { int? } } }
      end
      required(:action).filled(:str?)
    end

    # Dependency injection.
    # authenticatorは認証モジュールで必須(../authentication.rb)
    def initialize(meeting_repo: MeetingRepository.new,
                   category_repo: CategoryRepository.new,
                   article_repo: ArticleRepository.new,
                   author_repo: AuthorRepository.new,
                   article_reference_repo: ArticleReferenceRepository.new,
                   authenticator: JwtAuthenticator.new)
      @meeting_repo = meeting_repo
      @category_repo = category_repo
      @article_repo = article_repo
      @author_repo = author_repo
      @article_reference_repo = article_reference_repo
      @authenticator = authenticator
      @notifications = {}
    end

    # TODO: 追加議案の投稿期間にパラメータ不正があった場合、表示される画面に次のブロック会議の選択肢が含まれないのを修正すること
    # TODO: 寮生大会には議案を投稿させない

    def call(params)
      if params.valid?
        # TODO: 以下の採決項目のチェックをバリデーションクラスとして実装する
        categories = params[:article][:categories].map { |id| @category_repo.find(id) }
        if categories.find{ |c| c.name == '採決' || c.name == '採決予定' } && (!params[:article][:vote_content] || params[:article][:vote_content]&.strip&.empty?)
          # invalid params
          @meetings = @meeting_repo.in_time
          @next_meeting = @meeting_repo.find_most_recent
          @notifications = {error: {status: "Error:", message: "議案種別に『採決』または『採決予定』が指定されていますが、採決項目が入力されていません. もう一度確認してください"}}
        else
          meeting = @meeting_repo.find(params[:article][:meeting_id])
          if after_deadline?
            # 追加議案の投稿受理期間
            if meeting.id == @meeting_repo.find_most_recent&.id
              # 正常な保存処理
              #追加議案廃止によりchecked:trueとなっている
              save(params, checked: true)
            else
              # 指定されたブロック会議が追加議案を受理するブロック会議ではない場合
              @meetings = [@meeting_repo.find_most_recent]
              @notifications = {error: {status: "Error:", message: "現在は追加議案のみ投稿を受け付けています. 議案を投稿しようとしたブロック会議は追加議案を受け付けていない可能性があります. 次のブロック会議以降のブロック会議に議案を投稿したい場合は、次のブロック会議が終了してから議案を投稿してください."}}
            end
          else
            # 通常議案の投稿受理期間
            if meeting.deadline > Time.now
              # 正常な保存処理
              save(params, checked: true)
            else
              # meeting.deadline <= Time.now
              # 指定されたmeetingが締め切り後の場合→追加議案にならば投稿できるならメッセージ表示
              if meeting.date >= Date.today
                @meetings = [@meeting_repo.find_most_recent]
                @notifications = {error: {status: "Error:", message: "議案を投稿しようとしたブロック会議は既に締め切り日時を過ぎています. 追加議案として投稿することは可能ですのでもう一度投稿してください."}}
              else
                @meetings = @meeting_repo.in_time
                @notifications = {error: {status: "Error:", message: "議案を投稿しようとしたブロック会議は既に締め切り日時を過ぎています. 投稿できません."}}
              end
              @next_meeting = @meetings.first
            end
          end
        end
      else
        # invalid params
        @meetings = @meeting_repo.in_time
        @next_meeting = @meeting_repo.find_most_recent
        @notifications = {error: {status: "Error:", message: "入力された項目に不備があり投稿できません. もう一度確認してください"}}
      end
      @categories = @category_repo.all
      @recent_articles = @article_repo.of_recent(months: 3, past_meeting_only: false, with_relations: true)
      @article_refs_selected = { same: params[:article][:same_refs_selected], other: params[:article][:other_refs_selected] }
      self.status = 422
    end

    private
    def save(params, checked: false)
      author = @author_repo.create_with_plain_password(
        params[:article][:author][:name],
        params[:article][:author][:password]
      )
      format_number = params[:article][:format] ? 1 : 0
      article_params = params[:article].to_h.merge(author_id: author.id, checked: checked, format: format_number)
      article = @article_repo.create(article_params)
      categories = params[:article][:categories].map { |id| @category_repo.find(id) }
      # 採決項目の設定
      category_params = categories.map { |category|
        if category.require_content && (category.name == '採決' || category.name == '採決予定')
          { category_id: category.id, extra_content: params[:article][:vote_content] }
        else
          { category_id: category.id, extra_content: nil }
        end
      }
      @article_repo.add_categories(article, category_params)
      @article_reference_repo.create_refs(article.id, params[:article][:same_refs_selected], same: true)
      @article_reference_repo.create_refs(article.id, params[:article][:other_refs_selected], same: false)
      if checked
        flash[:notifications] = {success: {status: "Success", message: "正常に議案が投稿されました"}}
      else
        flash[:notifications] = {
          success: {status: "Success", message: "正常に議案が追加議案として投稿されました"},
          caution: {status: "注意：", message: "議案は追加議案として投稿されました. 通常議案として扱って欲しい正当な理由がある場合は資料委員会に相談してください."}
        }
      end
      if params[:action] == "post_article_with_table"
        redirect_to "#{routes.new_table_path}?article_id=#{article.id}"
      else
        redirect_to routes.article_path(id: article.id)
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
