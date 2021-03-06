class MeetingRepository < Hanami::Repository

  DEFAULT_ARTICLE_NUMBER = 10000

  associations do
    has_many :articles
    has_many :tables, through: :articles
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
    meeting = meetings
                .where(id: meeting_id)
                .map_to(Meeting)
                .one
    articles = ArticleRepository.new.by_meeting(meeting_id).to_a
    Meeting.new(meeting.to_h.merge(articles: articles))
  end

  def find_with_printed_articles(meeting_id)
    meeting = find_with_articles(meeting_id)
    meeting.articles.select!{ |article| article.printed }
    meeting
  end

  # 直近のブロック会議を返す（締め切りではなく日付で直近、前日のブロック会議も含まれる）
  def find_most_recent(today: Date.today)
    meetings.where(Sequel.lit('date >= ?', today - 1)).order{date.asc}.first
  end

  def find_past_meeting(meeting_id)
    query = "select * from meetings \
    where date < (select date from meetings where id = #{meeting_id}) \
    order by date desc limit 1"
    meetings.read(query).map_to(Meeting).one
  end

  # 締め切り前の議案一覧
  # nowを指定できるようにしてるのはテストしやすくするため
  def in_time(now: Time.now)
    meetings
      .where(Sequel.lit('deadline > ?', now))
      .order(:date)
      .limit(10)
      .to_a
  end

  def desc_by_date(limit: nil, offset: 0)
    meetings
      .order(:date)
      .limit(limit)
      .offset(offset)
      .reverse
      .to_a
  end

  def count
    meetings.count
  end
end
