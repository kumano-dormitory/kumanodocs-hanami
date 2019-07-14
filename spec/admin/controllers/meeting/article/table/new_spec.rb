require 'spec_helper'

describe Admin::Controllers::Meeting::Article::Table::New do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]) }
    let(:article) { Article.new(id: rand(1..100)) }
    let(:params) { { article_id: article.id } }

    it 'is successful' do
      action = Admin::Controllers::Meeting::Article::Table::New.new(
        article_repo: MiniTest::Mock.new.expect(:find, article, [article.id]),
        authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 200
      action.article.must_equal article
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Meeting::Article::Table::New.new(
        article_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 302
    end
  end
end
