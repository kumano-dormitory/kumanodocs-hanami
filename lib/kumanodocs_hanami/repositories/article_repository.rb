class ArticleRepository < Hanami::Repository  
  def by_meeting
    articles.to_a
      .group_by { |article| article.meeting_id }
      .map { |meeting_id, articles| [MeetingRepository.new.find(meeting_id), articles] }
  end
end
