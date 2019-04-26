module Web::Controllers::Article
  class Index
    include Web::Action
    expose :articles_by_meeting, :next_meeting, :during_meeting

    def initialize(article_repo: ArticleRepository.new,
                   meeting_repo: MeetingRepository.new)
      @article_repo = article_repo
      @meeting_repo = meeting_repo
    end

    def call(_params)
      @articles_by_meeting = @article_repo.group_by_meeting

      # 議事録作成リンクの表示
      @next_meeting = @meeting_repo.find_most_recent
      @during_meeting = during_meeting?
    end

    def navigation
      @navigation = {root: true}
    end
  end
end
