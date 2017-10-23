require 'spec_helper'

describe ArticleRepository do
  let(:meeting_repo) { MeetingRepository.new }
  let(:category_repo) { CategoryRepository.new }
  let(:article_repo) { ArticleRepository.new }
  let(:author_repo) { AuthorRepository.new }
  let(:ac_repo) { ArticleCategoryRepository.new }

  let(:article) { create(:article) }
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
    meeting_id = meeting.id
    create_list(:article, 5, meeting_id: meeting_id)
    meeting_with_articles = meeting_repo.find_with_articles(meeting_id)
    max = meeting_with_articles.articles.count
    numbers = [*1..max].shuffle
    articles_number = meeting_with_articles.articles.map.with_index do |article, index|
      {'article_id' => article.id, 'number' => numbers[index]}
    end
    article_repo.update_number(meeting_id, articles_number)
    meeting_repo.find_with_articles(meeting_id).articles.each_with_index do |article, index|
      article.number.must_equal numbers[index]
    end
  end
end
