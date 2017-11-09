require 'spec_helper'

describe ArticleRepository do
  def assert_update_articles_number(before_numbers, test_numbers)
    meeting = create(:meeting)
    before_numbers.shuffle.each do |number|
      create(:article, meeting_id: meeting.id, number: number)
    end
    meeting = meeting_repo.find_with_articles(meeting.id)

    shuffled_numbers = test_numbers.shuffle
    articles_number = meeting.articles.zip(shuffled_numbers).map do |article, number|
      {'article_id' => article.id, 'number' => number}
    end
    article_repo.update_number(meeting.id, articles_number)

    # 議案の番号が正しく変更されていることを確認
    meeting_repo.find_with_articles(meeting.id).articles.zip(shuffled_numbers).map do |article, number|
      article.number.must_equal number
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
    assert_update_articles_number([nil, nil, nil, nil, nil], [1, 2, 3, 4, 5])

    # 順序番号が変更前には一部がnilである場合
    assert_update_articles_number([1, 2, 3, nil, nil], [1, 2, 3, 4, 5])

    # 順序番号が変更前には全てnilではない場合
    assert_update_articles_number([1, 2, 3, 4, 5], [1, 2, 3, 4, 5])
  end
end
