require 'spec_helper'

describe Admin::Controllers::Meeting::Article::Index do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]) }
    let(:meeting) { Meeting.new(id: rand(1..50)) }
    let(:articles) { [Article.new(id: rand(1..100))] }
    let(:params) { { meeting_id: meeting.id } }

    it 'is successful' do
      action = Admin::Controllers::Meeting::Article::Index.new(
        article_repo: MiniTest::Mock.new.expect(:by_meeting, articles, [meeting.id]),
        meeting_repo: MiniTest::Mock.new.expect(:find, meeting, [meeting.id]),
        authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 200
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Meeting::Article::Index.new(
        article_repo: nil, meeting_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
