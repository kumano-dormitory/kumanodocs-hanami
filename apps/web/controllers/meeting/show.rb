module Web::Controllers::Meeting
  class Show
    include Web::Action
    expose :meeting, :article, :past_meeting, :past_comments,
           :messages, :blocks, :page, :max_page, :editable, :article_refs

    def initialize(meeting_repo: MeetingRepository.new,
                   article_repo: ArticleRepository.new,
                   block_repo: BlockRepository.new,
                   comment_repo: CommentRepository.new,
                   message_repo: MessageRepository.new,
                   article_reference_repo: ArticleReferenceRepository.new)
      @meeting_repo = meeting_repo
      @article_repo = article_repo
      @block_repo = block_repo
      @comment_repo = comment_repo
      @message_repo = message_repo
      @article_reference_repo = article_reference_repo
    end

    def call(params)
      @meeting = @meeting_repo.find_with_articles(params[:id])

      @page = params[:page]&.to_i || 0
      @page = 0 if @page < 0
      @page = @meeting.articles.length if @page > @meeting.articles.length


      if @page == 0
        # 議事録の０番を実装途中
        @past_meeting = @meeting_repo.find_past_meeting(@meeting.id)
        @past_comments = @comment_repo.by_meeting(@past_meeting.id)
                                      .group_by{|comment| comment[:article_id]}
      else
        if @meeting.articles.length > 0 # ブロック会議に議案が存在する場合
          @article = @article_repo.find_with_relations(@meeting.articles[@page - 1].id)
          @messages = @message_repo.by_article(@article.id).group_by{|message| message.comment_id}
          @article_refs = @article_reference_repo.find_refs(@article.id)
          @editable = if after_deadline?
            # 追加議案の編集期間
            @meeting_repo.find_most_recent.id == @article.meeting_id && !@article.checked
          else
            # 通常の編集期間
            @article.meeting.deadline > Time.now
          end
        end
      end

      @max_page = @meeting.articles.length
      @blocks = @block_repo.all
    end

    def navigation
      @navigation = {meeting: true, bn_meeting: true}
    end
  end
end
