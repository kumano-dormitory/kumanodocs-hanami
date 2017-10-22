class MeetingRepository < Hanami::Repository

  DEFAULT_ARTICLE_NUMBER = 10000

  associations do
    has_many :articles
  end

  def for_articles
    aggregate(:articles)
      .meetings
      .order(:date)
      .reverse
      .to_a
      .select { |meeting| !meeting.articles.empty? }
  end

  def find_with_articles(meeting_id)
    meeting = aggregate(:articles)
      .meetings
      .where(id: meeting_id)
      .as(Meeting)
      .one
    meeting
  end

  # 締め切り前の議案一覧
  # nowを指定できるようにしてるのはテストしやすくするため
  def in_time(now: Time.now)
    meetings
      .where('deadline > ?', now)
      .order(:date)
      .limit(10)
      .to_a
  end

  def desc_by_date
    meetings
      .order(:date)
      .reverse
      .to_a
  end
end
