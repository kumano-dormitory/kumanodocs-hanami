module Web::Controllers::Article
  class Show
    include Web::Action
    expose :article, :blocks, :editable, :messages, :enable_html, :article_refs

    def initialize(article_repo: ArticleRepository.new,
                   block_repo: BlockRepository.new,
                   meeting_repo: MeetingRepository.new,
                   message_repo: MessageRepository.new,
                   article_reference_repo: ArticleReferenceRepository.new,
                   authenticator: JwtAuthenticator.new)
      @article_repo = article_repo
      @block_repo = block_repo
      @meeting_repo = meeting_repo
      @message_repo = message_repo
      @article_reference_repo = article_reference_repo
      @authenticator = authenticator
    end

    def call(params)
      @article = @article_repo.find_with_relations(params[:id])
      @blocks = @block_repo.all
      @messages = @message_repo.by_article(@article.id).group_by{|message| message.comment_id}
      @article_refs = @article_reference_repo.find_refs(@article.id)
      @editable = if after_deadline?
        # 追加議案の編集期間
        @meeting_repo.find_most_recent.id == @article.meeting_id && !@article.checked && !@article.printed
      else
        # 通常の編集期間
        @article.meeting.deadline > Time.now
      end
      @enable_html = !!params[:enable_html]
    end

    def navigation
      @navigation = {bn_search: true}
    end
  end
end
