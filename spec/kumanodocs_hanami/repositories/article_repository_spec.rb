require 'spec_helper'

describe ArticleRepository do
  def create_articles(meeting_id, numbers)
    numbers.map do |number|
      create(:article, meeting_id: meeting_id, number: number)
    end
  end

  def assert_update_articles_number(meeting_id, articles, test_numbers)
    shuffled_numbers = test_numbers.shuffle
    articles_number = articles.zip(shuffled_numbers).map do |article, number|
      {'article_id' => article.id, 'number' => number}
    end
    article_repo.update_number(meeting_id, articles_number)

    # 議案の番号が正しく変更されていることを確認
    target_articles = meeting_repo.find_with_articles(meeting_id).articles
    target_articles.zip(shuffled_numbers).map do |article, number|
      article.number.must_equal number
    end
  end

  def assert_update_articles_status(meeting_id, articles, test_status)
    articles_status = articles.zip(test_status).map do |article, status|
      {
        'article_id' => article.id,
        'checked' => (status[:checked] ? true : nil),
        'printed' => (status[:printed] ? true : nil)
      }
    end
    article_repo.update_status(articles_status)

    # 議案の状態が正しく変更されていることを確認
    target_articles = meeting_repo.find_with_articles(meeting_id).articles
    target_articles.zip(test_status).map do |article, status|
      article.checked.must_equal status[:checked]
      article.printed.must_equal status[:printed]
    end
  end

  let(:meeting_repo) { MeetingRepository.new }
  let(:category_repo) { CategoryRepository.new }
  let(:article_repo) { ArticleRepository.new }
  let(:author_repo) { AuthorRepository.new }
  let(:ac_repo) { ArticleCategoryRepository.new }
  let(:article) { create(:article) }
  let(:categories) { create_list(:category, 5) }

  it 'categoryを追加できること' do
    datas = categories.sample(2).map { |category| { category_id: category.id } }
    article_repo.add_categories(article, datas)
    _article = article_repo.find_with_relations(article.id)
    _article.article_categories.size.must_equal 2
  end

  it 'categoryを更新できること' do
    datas = categories.sample(3).map { |category| { category_id: category.id } }
    article_repo.update_categories(article, datas)

    _article = article_repo.find_with_relations(article.id)
    _article.article_categories.size.must_equal 3
  end

  it 'authorとcategoryを一緒に読み込めること' do
    aggr_article = article_repo.find_with_relations(article.id)
    aggr_article.article_categories.wont_be_nil
    aggr_article.author.wont_be_nil
  end

  it 'article_numberの変更ができること' do
    # 順序番号が変更前には全てnilの場合
    meeting = create(:meeting)
    articles = create_articles(meeting.id, [nil, nil, nil, nil, nil])
    assert_update_articles_number(meeting.id, articles, [1, 2, 3, 4, 5])

    # 順序番号が変更前には一部がnilである場合
    meeting = create(:meeting)
    articles = create_articles(meeting.id, [1, 2, 3, nil, nil].shuffle)
    assert_update_articles_number(meeting.id, articles, [1, 2, 3, 4, 5])

    # 順序番号が変更前には全てnilではない場合
    meeting = create(:meeting)
    articles = create_articles(meeting.id, [1, 2, 3, 4, 5].shuffle)
    assert_update_articles_number(meeting.id, articles, [1, 2, 3, 4, 5])
  end

  it 'article_statusの変更ができること' do
    meeting = create(:meeting)
    test_status = (1..5).map{ {checked: [true, false].sample, printed: [true, false].sample} }
    articles = create_list(:article, 5, meeting_id: meeting.id, checked: false, printed: false)

    assert_update_articles_status(meeting.id, articles, test_status)
  end
end
