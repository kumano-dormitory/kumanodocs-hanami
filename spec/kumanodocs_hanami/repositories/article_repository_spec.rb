require 'spec_helper'

describe ArticleRepository do
  def assert_update_articles_number(meeting_id, test_numbers)
    meeting = meeting_repo.find_with_articles(meeting_id)
    shuffled_numbers = test_numbers.shuffle

    articles_number = meeting.articles.zip(shuffled_numbers).map do |article, number|
      {'article_id' => article.id, 'number' => number}
    end
    article_repo.update_number(meeting_id, articles_number)

    # 議案の番号が正しく変更されていることを確認
    meeting_repo.find_with_articles(meeting_id).articles.zip(shuffled_numbers).map do |article, number|
      article.number.must_equal number
    end
  end

  let(:meeting_repo) { MeetingRepository.new }
  let(:category_repo) { CategoryRepository.new }
  let(:article_repo) { ArticleRepository.new }
  let(:author_repo) { AuthorRepository.new }
  let(:ac_repo) { ArticleCategoryRepository.new }

  let(:article) { create(:article) }
  let(:articles) { create_list(:article, 5, meeting_id: meeting.id) }
  let(:categories) { create_list(:category, 5) }
  let(:meeting) { create(:meeting) }

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
    assert_update_articles_number(meeting.id, [1, 2, 3, 4, 5])
    assert_update_articles_number(meeting.id, [1, 2, 3, nil, nil])
    assert_update_articles_number(meeting.id, [nil, nil, nil, nil, nil])
  end
end
