class MeetingRepository < Hanami::Repository
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
end
