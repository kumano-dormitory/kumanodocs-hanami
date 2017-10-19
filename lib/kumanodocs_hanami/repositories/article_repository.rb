class ArticleRepository < Hanami::Repository

  DEFAULT_ARTICLE_NUMBER = 10000

  associations do
    belongs_to :meeting
    belongs_to :author
    has_many :article_categories
    has_many :categories, through: :article_categories
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
    articles_of_meeting = articles.where(meeting_id: id).to_a
    articles_of_meeting.sort_by { |article| article.number || DEFAULT_ARTICLE_NUMBER }
  end

  def find_with_relations(id)
    article = aggregate(:article_categories, :meeting, :author, :categories)
                .where(id: id).map_to(Article).one
  end

  def add_categories(article, datas)
    # datas.each { |data| assoc(:article_cateogries, article).add(data) }
    # とも書けるが、SQLの数が増えるので以下のように書いている。
    # assoc(:article_cateogries, article).add(datas)のように書けたらいいのに。
    datas.map! { |data| data.merge!(article_id: article.id) }
    ArticleCategoryRepository.new.create(datas)
    return nil
  end

  def update_categories(article, datas)
    transaction do
      assoc(:article_categories, article).delete
      add_categories(article, datas)
    end
  end
end
