require 'spec_helper'
require_relative '../../../../apps/admin/controllers/article_status/edit'

describe Admin::Controllers::ArticleStatus::Edit do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]) }
    let(:meeting) { Meeting.new(id: rand(1..50)) }
    let(:params) { { id: meeting.id } }

    it 'is successful' do
      action = Admin::Controllers::ArticleStatus::Edit.new(
        meeting_repo: MiniTest::Mock.new.expect(:find_with_articles, meeting, [meeting.id]),
        authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 200
      action.meeting.must_equal meeting
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::ArticleStatus::Edit.new(
        meeting_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 302
    end
  end
end
