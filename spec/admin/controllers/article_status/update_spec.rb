require 'spec_helper'
require_relative '../../../../apps/admin/controllers/article_status/update'

describe Admin::Controllers::ArticleStatus::Update do
  describe 'when user is logged in' do
    def assert_invalid_params(invalid_params_merged)
      action = Admin::Controllers::ArticleStatus::Update.new(
        meeting_repo: MiniTest::Mock.new.expect(:find_with_articles, meeting, [params[:id]]),
        article_repo: nil, admin_history_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      invalid_params = params.deep_merge(invalid_params_merged)
      response = action.call(invalid_params)

      _(response[0]).must_equal 422
      _(action.meeting).must_equal meeting
    end

    let(:meeting) { Meeting.new(id: rand(1..50)) }
    let(:articles_status) {
      (1..5).map{ |id| {'article_id' => id, 'checked' => [true, nil].sample} }
    }
    let(:params) {
      {
        meeting: { articles: articles_status },
        id: meeting.id,
      }
    }

    it 'is successful' do
      article_repo = MiniTest::Mock.new.expect(:update_status, nil, [articles_status])
      action = Admin::Controllers::ArticleStatus::Update.new(
        article_repo: article_repo, meeting_repo: nil,
        admin_history_repo: MiniTest::Mock.new.expect(:add, nil, [:article_status_update, String]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(params)

      _(response[0]).must_equal 302
      _(article_repo.verify).must_equal true
    end

    it 'is rejected' do
      assert_invalid_params({meeting: nil})
      assert_invalid_params({meeting: rand(-100..100)})
      assert_invalid_params({meeting: ""})
      assert_invalid_params({meeting: {articles: nil}})
      assert_invalid_params({meeting: {articles: {id: rand(1..100)}}})
      assert_invalid_params({meeting: {articles: "abc"}})
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::ArticleStatus::Update.new(
        meeting_repo: nil, article_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
