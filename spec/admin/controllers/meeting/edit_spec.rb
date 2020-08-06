require_relative '../../../spec_helper'

describe Admin::Controllers::Meeting::Edit do
  let(:action) { Admin::Controllers::Meeting::Edit.new(meeting_repo: meeting_repo, authenticator: authenticator) }
  let(:meeting) { Meeting.new(id: rand(1..100)) }
  let(:params) { {id: meeting.id} }

  describe 'when user is logged in' do
    let(:meeting_repo) { MiniTest::Mock.new.expect(:find, meeting, [meeting.id]) }
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]) }
    it 'is successful' do
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.meeting).must_equal meeting
    end
  end

  describe 'when user is not logged in' do
    let(:meeting_repo) { nil }
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    it 'is redirected' do
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
