class ArticleRepository < Hanami::Repository
  associations do
    belongs_to :author
  end

  def by_meeting
    articles.to_a
      .group_by { |article| article.meeting_id }
      .map { |meeting_id, articles| [MeetingRepository.new.find(meeting_id), articles] }
  end

  def with_author(id)
    aggregate(:author).where(id: id).map_to(Article).one
  end
end
