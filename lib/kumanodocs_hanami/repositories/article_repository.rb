class ArticleRepository < Hanami::Repository
  associations do
    belongs_to :author
  end

  def update_number(meeting_id, articles_number)
    # numberをnilで初期化してからupdateする
    articles.where(meeting_id: meeting_id).update(number: nil)
    articles_number.each do |article_attr|
      num = article_attr['number'].eql?("") ? nil : article_attr['number']
      update(article_attr['article_id'], number: num)
    end
  end

  def update_status(articles_status)
    articles_status.each do |status|
      checked = !status['checked'].nil?
      printed = !status['printed'].nil?
      update(status['article_id'], checked: checked, printed: printed)
    end
  end

  def group_by_meeting
    articles.to_a
            .group_by { |article| article.meeting_id }
            .map { |meeting_id, articles| [MeetingRepository.new.find(meeting_id), articles] }
  end

  def by_meeting(id)
    articles.where(meeting_id: id).to_a
  end

  def with_author(id)
    aggregate(:author).where(id: id).map_to(Article).one
  end
end
