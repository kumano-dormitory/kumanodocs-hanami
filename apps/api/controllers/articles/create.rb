module Api::Controllers::Articles
  class Create
    include Api::Action

    params do
      optional(:token).filled(:str?)
      required(:meeting_id).filled(:int?)
      required(:categories) { array? { min_size?(1) & each { int? } } }
      required(:title).filled(:str?)
      required(:author_name).filled(:str?)
      required(:password).filled(:str?)
      required(:format).filled(:int?)
      required(:body).filled(:str?)
      optional(:vote_content).maybe(:str?)
      optional(:same_refs) { array? { each { int? } } }
      optional(:other_refs) { array? { each { int? } } }
    end

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
      @body = ""
      @status_code = 422
    end

    def call(params)
      if params.valid?
        categories = params[:categories].map { |id| @category_repo.find(id) }
        if categories.find{ |c| c.name == '採決' || c.name == '採決予定' } && (!params[:vote_content] || params[:vote_content]&.strip&.empty?)
          # invalid params
          @body = '{"response_code":422,"message":"Unprocessable Entity","response_body":{"status":"Error:","message":"議案種別に『採決』または『採決予定』が指定されていますが、採決項目が入力されていません. もう一度確認してください"}}'
        else
          meeting = @meeting_repo.find(params[:meeting_id])
          if after_deadline?
            # 追加議案の投稿受理期間
            if meeting.id == @meeting_repo.find_most_recent&.id
              # 正常な保存処理
              save(params, checked: false)
            else
              # 指定されたブロック会議が追加議案を受理するブロック会議ではない場合
              @body = '{"response_code":422,"message":"Unprocessable Entity","response_body":{"status":"Error:","message":"現在は追加議案のみ投稿を受け付けています. 議案を投稿しようとしたブロック会議は追加議案を受け付けていない可能性があります. 次のブロック会議以降のブロック会議に議案を投稿したい場合は、次のブロック会議が終了してから議案を投稿してください."}}'
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
                @body = '{"response_code":422,"message":"Unprocessable Entity","response_body":{"status":"Error:","message":"議案を投稿しようとしたブロック会議は既に締め切り日時を過ぎています. 追加議案として投稿することは可能ですのでもう一度投稿してください."}}'
              else
                @body = '{"response_code":422,"message":"Unprocessable Entity","response_body":{"status":"Error:","message":"議案を投稿しようとしたブロック会議は既に締め切り日時を過ぎています. 投稿できません."}}'
              end
            end
          end
        end
      else
        # invalid params
        @body = '{"response_code":422,"message":"Unprocessable Entity","response_body":{"status":"Error:","message":"入力された項目に不備があり投稿できません. もう一度確認してください"}}'
      end
      self.format = :json
      self.body = @body
      self.status = @status_code
    end

    private
    def save(params, checked: false)
      author = @author_repo.create_with_plain_password(
        params[:author_name],
        params[:password]
      )
      article_params = params.to_h.merge(author_id: author.id, checked: checked)
      article = @article_repo.create(article_params)
      categories = params[:categories].map { |id| @category_repo.find(id) }
      # 採決項目の設定
      category_params = categories.map { |category|
        if category.require_content && (category.name == '採決' || category.name == '採決予定')
          { category_id: category.id, extra_content: params[:vote_content] }
        else
          { category_id: category.id, extra_content: nil }
        end
      }
      @article_repo.add_categories(article, category_params)
      @article_reference_repo.create_refs(article.id, params[:same_refs], same: true)
      @article_reference_repo.create_refs(article.id, params[:other_refs], same: false)
      if checked
        @body = '{"response_code":200,"message":"OK","response_body":{"status":"Success","message":"正常に議案が投稿されました."}}'
      else
        @body = '{"response_code":200,"message":"OK","response_body":{"status":"Success","message":"議案は正常に追加議案として投稿されました. 通常議案として扱って欲しい正当な理由がある場合は資料委員会に相談してください."}}'
      end
      @status_code = 200
    end

    # 直近のブロック会議の締め切り後かどうかを返す 締め切り〜会議開始までならばtrue
    def after_deadline?(now: Time.now)
      recent_meeting = @meeting_repo.find_most_recent
      return false unless recent_meeting
      now.between?(recent_meeting.deadline, recent_meeting.date.to_time + (60 * 60 * 22))
    end
  end
end
