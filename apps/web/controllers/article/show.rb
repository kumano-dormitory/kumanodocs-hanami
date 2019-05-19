module Web::Controllers::Article
  class Show
    include Web::Action
    expose :article, :blocks, :editable, :messages

    def initialize(article_repo: ArticleRepository.new,
                   block_repo: BlockRepository.new,
                   meeting_repo: MeetingRepository.new,
                   message_repo: MessageRepository.new)
      @article_repo = article_repo
      @block_repo = block_repo
      @meeting_repo = meeting_repo
      @message_repo = message_repo
    end

    def call(params)
      @article = @article_repo.find_with_relations(params[:id])
      @blocks = @block_repo.all
      @messages = @message_repo.by_article(@article.id).group_by{|message| message.comment_id}
      @editable = if after_deadline?
        # 追加議案の編集期間
        @meeting_repo.find_most_recent.id == @article.meeting_id && !@article.checked
      else
        # 通常の編集期間
        @article.meeting.deadline > Time.now
      end
    end

    def navigation
      @navigation = {bn_search: true}
    end
  end
end
