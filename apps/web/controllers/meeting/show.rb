module Web::Controllers::Meeting
  class Show
    include Web::Action
    expose :meeting, :article, :blocks, :page, :max_page, :editable

    def initialize(meeting_repo: MeetingRepository.new,
                   article_repo: ArticleRepository.new,
                   block_repo: BlockRepository.new)
      @meeting_repo = meeting_repo
      @article_repo = article_repo
      @block_repo = block_repo
    end

    def call(params)
      @meeting = @meeting_repo.find_with_articles(params[:id])

      @page = params[:page]&.to_i || 1
      @page = 1 if @page <= 0
      @page = @meeting.articles.length if @page > @meeting.articles.length

      if @meeting.articles.length > 0 # ブロック会議に議案が存在する場合
        @article = @article_repo.find_with_relations(@meeting.articles[@page - 1].id)
        @editable = if after_deadline?
          # 追加議案の編集期間
          @meeting_repo.find_most_recent.id == @article.meeting_id && !@article.checked
        else
          # 通常の編集期間
          @article.meeting.deadline > Time.now
        end
      end
      @max_page = @meeting.articles.length
      @blocks = @block_repo.all
    end

    def navigation
      @navigation = {meeting: true}
    end
  end
end
