require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/destroy'

describe Web::Controllers::Article::Destroy do
  describe 'when user is logged in' do
    let(:article) { Article.new(id: rand(1..100), author: author) }
    let(:author) { Author.new(id: rand(1..100), crypt_password: crypt_password)}
    let(:password) { Faker::Internet.password }
    let(:crypt_password) { Digest::SHA256.hexdigest(password) }

    it 'is successful destroy article' do
      article_repo = MiniTest::Mock.new.expect(
        :find_with_relations, article, [article.id]
      ).expect(
        :delete, nil, [article.id]
      )
      action = Web::Controllers::Article::Destroy.new(
        article_repo: article_repo,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      params = { id: article.id, article: {password: password} }
      response = action.call(params)

      _(response[0]).must_equal 302
      _(article_repo.verify).must_equal true
    end

    it 'is rejected by auth failure' do
      article_repo = MiniTest::Mock.new.expect(:find_with_relations, article, [article.id])
      action = Web::Controllers::Article::Destroy.new(
        article_repo: article_repo,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      params = { id: article.id, article: {password: password + "hoge"} }
      response = action.call(params)
      _(response[0]).must_equal 401
      _(action.article).must_equal article
    end
  end


  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    it 'is redirected' do
      action = Web::Controllers::Article::Destroy.new(
        article_repo: nil, authenticator: authenticator
      )
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
