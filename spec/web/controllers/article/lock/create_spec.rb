require 'spec_helper'
require_relative '../../../../../apps/web/controllers/article/lock/create'

describe Web::Controllers::Article::Lock::Create do
  describe 'when user is logged in' do
    let(:lock_key) { Author.generate_lock_key }
    let(:password) { Faker::Internet.password }
    let(:crypt_password) { Author.crypt(password) }
    let(:author) { Author.new(id: rand(1..5), name: Faker::Name.name, crypt_password: crypt_password) }
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
        author_repo: author_repo,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      response = action.call(valid_params)

      _(response[0]).must_equal 302
      _(response[1]['Set-Cookie']).must_match "article_lock_key=#{lock_key}"
      _(article_repo.verify).must_equal true
      _(author_repo.verify).must_equal true
    end

    it 'is rejected' do
      article_repo = MiniTest::Mock.new.expect(:find_with_relations, article, [valid_params[:article_id]])
      action = Web::Controllers::Article::Lock::Create.new(
        article_repo: article_repo, author_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      invalid_params = valid_params.deep_merge({ author: {password: Faker::Internet.password} })
      response = action.call(invalid_params)

      _(response[0]).must_equal 401
      _(article_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) {  }

    it 'is redirected' do
      action = Web::Controllers::Article::Lock::Create.new(
        article_repo: nil, author_repo: nil, authenticator: authenticator
      )
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
