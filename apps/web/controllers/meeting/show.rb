# ====
# ブロック会議の詳細表示アクション
# ====
# ブロック会議の詳細ページを表示する
# ブロック会議に含まれる議案をページングして表示する
# = 主な処理
# - 指定されたページ番号（議案番号）の議案を表示する
# - ブロック会議に含まれる議案への目次を表示する
# - 0番の議案が指定された場合には、「前回のブロック会議から」（前回のブロック会議の議事録一覧）を表示する

module Web::Controllers::Meeting
  class Show
    include Web::Action
    expose :meeting, :article, :past_meeting, :past_comments, :past_messages,
           :messages, :blocks, :page, :max_page, :editable, :article_refs

    def initialize(meeting_repo: MeetingRepository.new,
                   article_repo: ArticleRepository.new,
                   block_repo: BlockRepository.new,
                   comment_repo: CommentRepository.new,
                   message_repo: MessageRepository.new,
                   article_reference_repo: ArticleReferenceRepository.new,
                   authenticator: JwtAuthenticator.new)
      @meeting_repo = meeting_repo
      @article_repo = article_repo
      @block_repo = block_repo
      @comment_repo = comment_repo
      @message_repo = message_repo
      @article_reference_repo = article_reference_repo
      @authenticator = authenticator
    end

    def call(params)
      @meeting = @meeting_repo.find_with_articles(params[:id])

      @page = params[:page]&.to_i || 0
      @page = 0 if @page < 0
      @page = 1 if @page == 0 && @meeting.type != 0 #ブロック会議以外なら０番を表示しない
      @page = @meeting.articles.length if @page > @meeting.articles.length


      if @page == 0
          # ブロック会議の０番（前回のブロック会議から）
          @past_meeting = @meeting_repo.find_past_meeting(@meeting.id)
          @past_comments = @comment_repo.by_meeting(@past_meeting.id)
                                        .group_by{|comment| comment[:article_id]}
          @past_messages = @message_repo.by_meeting(@past_meeting.id)
                                        .group_by{|message| message[:comment_id]}
      else
        if @meeting.articles.length > 0 # ブロック会議に議案が存在する場合
          @article = @article_repo.find_with_relations(@meeting.articles[@page - 1].id)
          @messages = @message_repo.by_article(@article.id).group_by{|message| message.comment_id}
          @article_refs = @article_reference_repo.find_refs(@article.id)
          @editable = if after_deadline?
            # 追加議案の編集期間
            @meeting_repo.find_most_recent.id == @article.meeting_id && !@article.checked && !@article.printed
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
      @navigation = {meeting: true, bn_meeting: true, enable_dark: true}
    end
  end
end
