class ArticleRepository < Hanami::Repository
  associations do
    belongs_to :author
    has_many :article_categories
    has_many :categories, through: :article_categories
  end

  def group_by_meeting
    articles.to_a
            .group_by { |article| article.meeting_id }
            .map { |meeting_id, articles| [MeetingRepository.new.find(meeting_id), articles] }
  end

  def by_meeting(id)
    articles.where(meeting_id: id).to_a
  end

  def find_with_relations(id)
    article = aggregate(:article_categories, :author, :categories)
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
