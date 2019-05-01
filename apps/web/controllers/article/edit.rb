module Web::Controllers::Article
  class Edit
    include Web::Action
    expose :article, :meetings, :categories

    def initialize(article_repo: ArticleRepository.new,
                   meeting_repo: MeetingRepository.new,
                   category_repo: CategoryRepository.new)
      @article_repo = article_repo
      @meeting_repo = meeting_repo
      @category_repo = category_repo
    end

    def call(params)
      @article = @article_repo.find_with_relations(params[:id])
      if @article.author.locked? && @article.author.lock_key == cookies[:article_lock_key]
        if after_deadline?
          # 追加議案のみ編集可の期間
          # TODO: 次のブロック会議以降の議案も編集可にする
          if @meeting_repo.find_most_recent.id == @article.meeting.id && !@article.checked
            @meetings = [@meeting_repo.find_most_recent]
            @categories = @category_repo.all
          else
            flash[:notifications] = {error: {status: "Error:", message: "ブロック会議の締め切りを過ぎているか、追加議案ではないため議案の編集ができません（編集したい場合は資料委員会に相談してください）. 次のブロック会議以降のブロック会議に含まれる議案を編集したい場合は、次のブロック会議終了後に編集してください."}}
            redirect_to routes.article_path(id: @article.id)
          end
        else
          # 締め切り前のすべての議案が編集可の期間
          if @article.meeting.deadline > Time.now
            @meetings = @meeting_repo.in_time
            @categories = @category_repo.all
          else
            flash[:notifications] = {error: {status: "Error:", message: "ブロック会議の締め切りを過ぎているため、議案の編集はできません. 編集する必要がある場合は資料委員会に相談してください."}}
            redirect_to routes.article_path(id: @article.id)
          end
        end
      else
        redirect_to routes.new_article_lock_path(article_id: article.id)
      end
    end
  end
end
