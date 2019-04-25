class ArticleRepository < Hanami::Repository

  DEFAULT_ARTICLE_NUMBER = 10000

  associations do
    belongs_to :meeting
    belongs_to :author
    has_many :article_categories
    has_many :categories, through: :article_categories
    has_many :comments
    has_many :tables
  end

  def search(keywords, page=1, limit=20)
    keys = keywords.map { |keyword|
      key = articles.dataset.escape_like(keyword)
      Sequel.|(
        Sequel.ilike(:title, "%#{key}%"),
        Sequel.ilike(:body, "%#{key}%"),
        Sequel.ilike(authors[:name], "%#{key}%")
      )
    }
    aggregate(:author, :meeting)
      .articles
      .select_append(authors[:name], meetings[:date])
      .join(authors)
      .join(meetings)
      .where(Sequel.&(*keys))
      .order(meetings[:date].qualified.desc,
        articles[:number].qualified.asc,
        articles[:id].qualified.desc)
      .limit(limit)
      .offset((page - 1) * limit)
  end

  def search_count(keywords)
    keys = keywords.map { |keyword|
      key = articles.dataset.escape_like(keyword)
      Sequel.|(
        Sequel.ilike(:title, "%#{key}%"),
        Sequel.ilike(:body, "%#{key}%"),
        Sequel.ilike(authors[:name], "%#{key}%")
      )
    }
    articles
      .join(authors)
      .where(Sequel.&(*keys))
      .count
  end

  def update_number(meeting_id, articles_number)
    transaction do
      # データベースのUNIQUE制約にひっかからないようにすべてnilで初期化する
      articles.where(meeting_id: meeting_id).update(number: nil)
      # TODO: meetingに含まれないarticleが改変されることを防ぐ
      articles_number.each do |article_attr|
        update(article_attr['article_id'], number: article_attr['number'])
      end
    end
  end

  def create_with_related_entities(author_params, category_params, article_params)
    author = AuthorRepository.new.create_with_plain_password(
      author_params[:name],
      author_params[:password]
    )
    article = create(article_params.merge(author_id: author.id))
    add_categories(article, category_params)
    article
  end

  def update_status(articles_status)
    articles_status.each do |status|
      checked = !status['checked'].nil?
      printed = !status['printed'].nil?
      update(status['article_id'], checked: checked, printed: printed)
    end
  end

  def group_by_meeting(limit = 10)
    # TODO: articleをすべて取得してからsliceをかけるのは処理が遅い
    # whereを使って、ある程度会議日程で絞ってからsliceをかけたほうが良い
    ret = articles.select_append(meetings[:date])
      .join(meetings)
      .order(meetings[:date].qualified.desc, articles[:number].asc(nulls: :last))
      .to_a
      .group_by { |article| article.meeting_id }
      .map { |meeting_id, articles| [MeetingRepository.new.find(meeting_id), articles] }
    ret.slice(0, limit)
  end

  def before_deadline(date: Time.now)
    articles
      .select_append(meetings[:deadline])
      .join(meetings)
      .where(Sequel.lit('? > ?', meetings[:deadline].qualified, date))
      .order(meetings[:deadline].desc, articles[:number].asc(nulls: :last))
      .to_a
  end

  def by_meeting(id)
    articles.where(meeting_id: id)
      .order(articles[:number].asc(nulls: :last), articles[:id].asc)
  end

  def find_with_relations(id)
    article = aggregate(:article_categories, :meeting, :author, :categories, :comments, :tables)
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
