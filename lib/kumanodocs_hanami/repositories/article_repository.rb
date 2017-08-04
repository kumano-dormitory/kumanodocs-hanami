class ArticleRepository < Hanami::Repository
  associations do
    belongs_to :author
  end

  def update_status(status)
    checked = !status['checked'].nil?
    printed = !status['printed'].nil?
    update(status['article_id'], checked: checked, printed: printed)
  end

  def group_by_meeting
    articles.to_a
      .group_by { |article| article.meeting_id }
      .map { |meeting_id, articles| [MeetingRepository.new.find(meeting_id), articles] }
  end

  def by_meeting(id)
    articles.
      where(meeting_id: id).to_a
  end

  def with_author(id)
    aggregate(:author).where(id: id).map_to(Article).one
  end
end
