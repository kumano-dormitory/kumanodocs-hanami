require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/destroy'

describe Web::Controllers::Article::Destroy do
  let(:action) { Web::Controllers::Article::Destroy.new }
  let(:article_repo) { ArticleRepository.new }
  let(:author_repo) { AuthorRepository.new }
  let(:author_name) { Faker::Name.name }
  let(:password) { Faker::Internet.password }

  it 'is successful' do
    author = author_repo.create_with_plain_password(author_name, password)
    article = create(:article, author_id: author.id)
    pre_article_count = article_repo.all.count
    params = { id: article.id, article: {password: password} }

    response = action.call(params)

    response[0].must_equal 302
    article_repo.all.count.must_equal pre_article_count - 1
  end

  it 'is rejected' do
    author = author_repo.create_with_plain_password(author_name, password)
    article = create(:article, author_id: author.id)
    params = { id: article.id, article: {password: password + "hoge"} }
    response = action.call(params)
    response[0].must_equal 401
  end
end
