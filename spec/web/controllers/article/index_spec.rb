require_relative '../../../spec_helper'

describe Web::Controllers::Article::Index do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]) }
    let(:article_repo) { MiniTest::Mock.new.expect(:group_by_meeting, [meeting]) }
    let(:meeting) { Meeting.new(id: rand(1..50)) }
    let(:params) { {loggedin: [nil, true].sample} }

    it 'is successful' do
      action = Web::Controllers::Article::Index.new(article_repo: article_repo, authenticator: authenticator)
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.articles_by_meeting).must_equal [meeting]
      _(action.save_token).must_equal (!!params[:loggedin])
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) { Web::Controllers::Article::Index.new(authenticator: authenticator) }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
