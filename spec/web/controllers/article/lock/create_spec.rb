require 'spec_helper'
require_relative '../../../../../apps/web/controllers/article/lock/create'

describe Web::Controllers::Article::Lock::Create do
  let(:lock_key) { Author.generate_lock_key }
  let(:password) { Faker::Internet.password }
  let(:author) {
    crypt_password = Author.crypt(password)
    Author.new(id: rand(1..5), name: Faker::Name.name, crypt_password: crypt_password)
  }
  let(:article) { Article.new(id: rand(1..5), author_id: author.id, author: author) }
  let(:valid_params) {
    {
      article_id: article.id,
      author: {
        password: password
      }
    }
  }

  it 'is successful' do
    article_repo = MiniTest::Mock.new.expect(:find_with_relations, article, [valid_params[:article_id]])
    author_repo = MiniTest::Mock.new.expect(:lock, lock_key, [author.id, valid_params[:author][:password]])
    action = Web::Controllers::Article::Lock::Create.new(
      article_repo: article_repo,
      author_repo: author_repo
    )

    response = action.call(valid_params)

    response[0].must_equal 302
    article_repo.verify.must_equal true
    author_repo.verify.must_equal true
  end

  it 'is rejected' do
    article_repo = MiniTest::Mock.new.expect(:find_with_relations, article, [valid_params[:article_id]])
    action = Web::Controllers::Article::Lock::Create.new(
      article_repo: article_repo
    )
    invalid_params = valid_params.deep_merge({ author: {password: password + "hoge"} })
    response = action.call(invalid_params)

    response[0].must_equal 401
    article_repo.verify.must_equal true
  end
end
