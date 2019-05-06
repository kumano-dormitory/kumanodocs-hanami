module Web::Controllers::Article
  class Index
    include Web::Action
    expose :articles_by_meeting, :next_meeting, :during_meeting, :blocks

    def initialize(article_repo: ArticleRepository.new,
                   meeting_repo: MeetingRepository.new,
                   block_repo: BlockRepository.new)
      @article_repo = article_repo
      @meeting_repo = meeting_repo
      @block_repo = block_repo
    end

    def call(_params)
      @articles_by_meeting = @article_repo.group_by_meeting

      # 議事録作成リンクの表示
      if during_meeting?
        @during_meeting = true
        @next_meeting = @meeting_repo.find_most_recent
        @blocks = @block_repo.by_meeting_with_comment_vote_count(@next_meeting.id)
      end
    end

    def navigation
      @navigation = {root: true}
    end
  end
end
