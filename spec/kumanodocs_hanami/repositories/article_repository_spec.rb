require 'spec_helper'

describe ArticleRepository do
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
end
