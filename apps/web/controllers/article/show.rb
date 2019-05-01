module Web::Controllers::Article
  class Show
    include Web::Action
    expose :article, :blocks, :editable

    def initialize(article_repo: ArticleRepository.new,
                   block_repo: BlockRepository.new,
                   meeting_repo: MeetingRepository.new)
      @article_repo = article_repo
      @block_repo = block_repo
      @meeting_repo = meeting_repo
    end

    def call(params)
      @article = @article_repo.find_with_relations(params[:id])
      @blocks = @block_repo.all
      @editable = if after_deadline?
        # 追加議案の編集期間
        @meeting_repo.find_most_recent.id == @article.meeting_id && !@article.checked
      else
        # 通常の編集期間
        @article.meeting.deadline > Time.now
      end
    end
  end
end
