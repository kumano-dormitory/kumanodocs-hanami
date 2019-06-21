class ArticleRepository < Hanami::Repository

  DEFAULT_ARTICLE_NUMBER = 10000

  associations do
    belongs_to :meeting
    belongs_to :author
    has_many :article_categories
    has_many :categories, through: :article_categories
    has_many :comments
    has_many :tables
    has_many :vote_results
  end

  def build_query(keywords, detail_search)
    if detail_search
      title_key = articles.dataset.escape_like(keywords[:title])
      author_key = articles.dataset.escape_like(keywords[:author])
      body_key = articles.dataset.escape_like(keywords[:body])
      [
        Sequel.ilike(:title, "%#{title_key}%"),
        Sequel.ilike(:body, "%#{body_key}%"),
        Sequel.ilike(authors[:name], "%#{author_key}%"),
        {article_categories[:category_id] => keywords[:categories]}
      ]
    else
      keywords.map { |keyword|
        key = articles.dataset.escape_like(keyword)
        Sequel.|(
          Sequel.ilike(:title, "%#{key}%"),
          Sequel.ilike(:body, "%#{key}%"),
          Sequel.ilike(authors[:name], "%#{key}%")
        )
      }
    end
  end

  def search(keywords, page=1, limit=20, detail_search: false)
    keys = build_query(keywords, detail_search)
    aggregate(:author, :meeting, :categories)
      .articles
      .select_append(authors[:name], meetings[:date])
      .join(authors)
      .join(meetings)
      .join(article_categories)
      .where(Sequel.&(*keys))
      .order(meetings[:date].qualified.desc,
        articles[:number].qualified.asc,
        articles[:id].qualified.desc)
      .limit(limit)
      .offset((page - 1) * limit)
      .map_to(Article)
      .to_a
  end

  def search_count(keywords, detail_search: false)
    keys = build_query(keywords, detail_search)
    articles
      .join(authors)
      .join(article_categories)
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

  def of_recent(months: 3, today: Date.today, past_meeting_only: false, with_relations: false)
    if past_meeting_only
      cond = Sequel.&(
        Sequel.lit('? > ?', meetings[:date].qualified, today << months),
        Sequel.lit('? < ?', meetings[:date].qualified, today)
      )
    else
      cond = Sequel.lit('? > ?', meetings[:date].qualified, today << months)
    end
    (with_relations ? aggregate(:meeting, :categories, :author) : articles)
      .select_append(meetings[:date])
      .join(meetings)
      .where(cond)
      .order(meetings[:date].qualified.desc, articles[:number].asc(nulls: :last), articles[:id].asc)
      .to_a
  end

  # BL会議当日の１８時以降であれば１８時前に投稿されたすべての議案を出力、１８時前であれば通常議案を出力する
  def for_download(meeting, after_6pm: false)
    date = meeting.date
    meeting_date_6pm = Time.new(date.year, date.mon, date.day, 18,0,0,"+09:00")
    if after_6pm
      cond = Sequel.&({meeting_id: meeting.id}, Sequel.|(Sequel.lit('updated_at < ?', meeting_date_6pm), {checked: true}))
    else
      cond = Sequel.&({meeting_id: meeting.id}, {checked: true})
    end
    articles.where(cond).order(articles[:number].asc(nulls: :last), articles[:id].asc).to_a
      .map{ |article| find_with_relations(article.id) }
  end

  def group_by_meeting(limit = 10, today: Date.today, months: 3)
    ret = of_recent(months: months, today: today, past_meeting_only: false)
      .group_by { |article| article.meeting_id }
      .map { |meeting_id, articles| [MeetingRepository.new.find(meeting_id), articles] }
    ret.slice(0, limit)
  end

  def before_deadline(date: Time.now)
    articles
      .select_append(meetings[:deadline])
      .join(meetings)
      .where(Sequel.lit('? > ?', meetings[:deadline].qualified, date))
      .order(meetings[:deadline].asc, articles[:number].asc(nulls: :last), articles[:id].asc)
      .to_a
  end

  # 注意： 前日にブロック会議がある場合、そのブロック会議に含まれる未チェック議案を返す
  def not_checked_for_next_meeting(now: Time.now)
    meeting = MeetingRepository.new.find_most_recent(today: now)
    articles
      .where(meeting_id: meeting.id, checked: false)
      .order(articles[:number].asc(nulls: :last), articles[:id].asc)
      .to_a
  end

  def by_meeting(id)
    aggregate(:author, :categories).where(meeting_id: id)
      .order(articles[:number].asc(nulls: :last), articles[:id].asc)
  end

  def find_with_relations(id, minimum: false)
    article = if minimum
      aggregate(:meeting, :author, :categories).where(id: id).map_to(Article).one
    else
      aggregate(:article_categories, :meeting, :author, :categories, :comments, :vote_results, :tables)
                .where(id: id).map_to(Article).one
    end
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
