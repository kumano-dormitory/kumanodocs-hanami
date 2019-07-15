module Web::Controllers::Article
  class Edit
    include Web::Action
    expose :article, :meetings, :categories, :recent_articles, :article_refs_selected

    def initialize(article_repo: ArticleRepository.new,
                   meeting_repo: MeetingRepository.new,
                   category_repo: CategoryRepository.new,
                   article_reference_repo: ArticleReferenceRepository.new,
                   authenticator: JwtAuthenticator.new)
      @article_repo = article_repo
      @meeting_repo = meeting_repo
      @category_repo = category_repo
      @article_reference_repo = article_reference_repo
      @authenticator = authenticator
    end

    def call(params)
      @article = @article_repo.find_with_relations(params[:id])
      if @article.author.locked? && @article.author.lock_key == cookies[:article_lock_key]
        if after_deadline?
          # 追加議案のみ編集可の期間
          # TODO: 次のブロック会議以降の議案も編集可にする
          if @meeting_repo.find_most_recent.id == @article.meeting.id && !@article.checked && !@article.printed
            @meetings = [@meeting_repo.find_most_recent]
          else
            flash[:notifications] = {error: {status: "Error:", message: "ブロック会議の締め切りを過ぎているか、追加議案であっても資料委員会が印刷済みのため議案の編集ができません（編集したい場合は資料委員会に相談してください）. 次のブロック会議以降のブロック会議に含まれる議案を編集したい場合は、次のブロック会議終了後に編集してください."}}
            redirect_to routes.article_path(id: @article.id)
          end
        else
          # 締め切り前のすべての議案が編集可の期間
          if @article.meeting.deadline > Time.now
            @meetings = @meeting_repo.in_time
          else
            flash[:notifications] = {error: {status: "Error:", message: "ブロック会議の締め切りを過ぎているため、議案の編集はできません. 編集する必要がある場合は資料委員会に相談してください."}}
            redirect_to routes.article_path(id: @article.id)
          end
        end
        @categories = @category_repo.all
        @recent_articles = @article_repo.of_recent(months: 3, past_meeting_only: false, with_relations: true)
        @article_refs_selected = @article_reference_repo.find_refs(@article.id, with_relations: false)
          .group_by{|ref| ref.same}.map{ |same,refs|
              { (same ? :same : :other) =>
                refs.map{|ref| (ref.article_old_id == @article.id ? ref.article_new_id : ref.article_old_id)} }
          }.inject(:merge)
      else
        redirect_to routes.new_article_lock_path(article_id: article.id)
      end
    end
  end
end
