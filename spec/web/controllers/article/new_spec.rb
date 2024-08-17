require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/new'

describe Web::Controllers::Article::New do
  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]) }
    let(:article) { Article.new(id: rand(1..100)) }
    let(:meetings) { [Meeting.new(id: rand(1..5))] }
    let(:categories) { [Category.new(id: rand(1..5))] }
    let(:params) { Hash[] }

    # TODO: 会議中か判定するサービスを実装したあとにテストを詳細に定義すること
    it 'is successful' do
      article_repo = Minitest::Mock.new.expect(:of_recent, [article], [Hash])
      action = Web::Controllers::Article::New.new(
        meeting_repo: Minitest::Mock.new.expect(:in_time, meetings),
        article_repo: article_repo,
        category_repo: Minitest::Mock.new.expect(:all, categories),
        authenticator: authenticator,
      )
      response = action.call(params)

      _(response[0]).must_equal 200
      _(action.meetings).must_equal meetings
      _(action.next_meeting).must_equal meetings[0]
      _(action.categories).must_equal categories
      _(action.recent_articles).must_equal [article]
      _(article_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, false), [nil]) }

    it 'is redirected' do
      action = Web::Controllers::Article::New.new(
        meeting_repo: nil, article_repo: nil, category_repo: nil,
        authenticator: authenticator
      )
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
