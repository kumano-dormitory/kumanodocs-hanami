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
      @during_meeting = if @next_meeting&.date then
        date = @next_meeting.date
        start_at = Time.new(date.year, date.mon, date.day, 21,45,0,"+09:00")
        end_at = Time.new(date.year, date.mon, date.day, 12,0,0,"+09:00") + (60 * 60 * 24)
        Time.now.between?(start_at, end_at)
      else
        false
      end
      p @meeting_repo.find_most_recent
    end

    def navigation
      @navigation = {root: true}
    end
  end
end
