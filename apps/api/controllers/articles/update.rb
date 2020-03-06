module Api::Controllers::Articles
  class Update
    include Api::Action

    params do
      optional(:token).filled(:str?)
      required(:id).filled(:int?)
      required(:meeting_id).filled(:int?)
      required(:categories) { array? { min_size?(1) & each { int? } } }
      required(:title).filled(:str?)
      required(:author_name).filled(:str?)
      required(:format).filled(:int?)
      required(:body).filled(:str?)
      optional(:vote_content).maybe(:str?)
      optional(:same_refs) { array? { each { int? } } }
      optional(:other_refs) { array? { each { int? } } }
      required(:lock_key).filled(:str?)
      required(:get_lock).filled(:bool?)
      optional(:password).filled(:str?)
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
      @body = ""
      @status_code = 422
    end

    def call(params)
      if params.valid?
        article = @article_repo.find_with_relations(params[:id])
        if article.author.lock_key == params[:lock_key]
          # 編集ロックが有効なので編集可能
          update_if_editable(article, params)
        else
          if params[:get_lock]
            if article.author.authenticate(params[:password])
              # 認証が成功したので編集可能
              update_if_editable(article, params)
            else
              @body = '{"response_code":403,"message":"Forbidden","response_body":{"status":"Error","message":"パスワードが不正です. 正しいパスワードを入力してください."}}'
              @status_code = 403
            end
          else
            @body = '{"response_code":401,"message":"Unauthorized","response_body":{"status":"Error","message":"編集を行うためには認証を行ってください."}}'
            @status_code = 401
          end
        end
      else
        @body = '{"response_code":422,"message":"Unprocessable Entity","response_body":{"status":"Error","message":"入力された項目に不備があり保存できません. もう一度確認してください."}}'
        @status_code = 422
      end
      self.format = :json
      self.body = @body
      self.status = @status_code
    end

    private
    def update(article, params)
      categories = params[:categories].map { |id| @category_repo.find(id) }
      # 採決項目の設定
      category_params = categories.map { |category|
        if category.require_content && (category.name == '採決' || category.name == '採決予定')
          { category_id: category.id, extra_content: params[:vote_content] }
        else
          { category_id: category.id, extra_content: nil }
        end
      }
      article_params = params.to_h.merge(
        format: (params[:article][:format] ? 1 : 0)
      )
      @article_repo.update_categories(article, category_params)
      @author_repo.update(article.author_id, {name: params[:author_name]})
      @article_repo.update(article.id, article_params)
      @author_repo.release_lock(article.author_id)
      @article_reference_repo.update_refs(article.id, params[:same_refs], params[:other_refs])
      @body = '{"response_code":200,"message":"OK","response_body":{"status":"Success","message":"正常に議案が編集されました."}}'
      @status_code = 200
    end

    def update_if_editable(article, params)
      if after_deadline?
        # 追加議案の編集期間
        if @meeting_repo.find_most_recent.id == article.meeting.id && !article.checked && !article.printed
          update(article, params)
        else
          @body = '{"response_code":422,"message":"Unprocessable Entity","response_body":{"status":"Error","message":"議案が追加議案ではないか、追加議案であっても資料委員会が印刷済みのため編集できません. 編集したい場合は資料委員会に相談してください."}}'
          @status_code = 422
        end
      else
        # 通常の編集期間
        if article.meeting.deadline > Time.now
          update(article, params)
        else
          @body = '{"response_code":422,"message":"Unprocessable Entity","response_body":{"status":"Error","message":"ブロック会議の締め切りを過ぎているため議案を編集できません. 編集したい場合は資料委員会に相談してください."}}'
          @status_code = 422
        end
      end
    end

    # 直近のブロック会議の締め切り後かどうかを返す 締め切り〜会議開始までならばtrue
    def after_deadline?(now: Time.now)
      recent_meeting = @meeting_repo.find_most_recent
      return false unless recent_meeting
      now.between?(recent_meeting.deadline, recent_meeting.date.to_time + (60 * 60 * 22))
    end
  end
end
