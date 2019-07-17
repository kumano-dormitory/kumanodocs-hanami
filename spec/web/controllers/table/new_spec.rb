require_relative '../../../spec_helper'

describe Web::Controllers::Table::New do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]) }
    let(:articles) { [Article.new(id: rand(1..5))] }
    let(:params) { {} }

    it 'is successful' do
      article_repo = MiniTest::Mock.new.expect(:before_deadline, articles)
      action = Web::Controllers::Table::New.new(article_repo: article_repo, authenticator: authenticator)
      response = action.call(params)

      response[0].must_equal 200
      action.articles.must_equal articles
      article_repo.verify.must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) { Web::Controllers::Table::New.new(authenticator: authenticator) }

    it 'is redirected' do
      response = action.call({})
      response[0].must_equal 302
    end
  end
end
