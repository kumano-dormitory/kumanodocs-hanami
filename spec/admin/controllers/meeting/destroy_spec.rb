require_relative '../../../spec_helper'

describe Admin::Controllers::Meeting::Destroy do
  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]) }
    let(:meeting) { Meeting.new(id: rand(1..50)) }
    let(:valid_params) { {id: meeting.id, meeting: {confirm: true}} }
    let(:invalid_params) { {id: meeting.id} }

    it 'is successful delete' do
      action = Admin::Controllers::Meeting::Destroy.new(
        meeting_repo: Minitest::Mock.new.expect(:find, meeting, [meeting.id])
                                        .expect(:delete, nil, [meeting.id]),
        admin_history_repo: Minitest::Mock.new.expect(:add, nil, [:meeting_destroy, String]),
        authenticator: authenticator,
      )
      response = action.call(valid_params)
      _(response[0]).must_equal 302
    end

    it 'is redirect for confirmation' do
      action = Admin::Controllers::Meeting::Destroy.new(
        meeting_repo: Minitest::Mock.new.expect(:find, meeting, [meeting.id]),
        admin_history_repo: nil,
        authenticator: authenticator,
      )
      response = action.call(invalid_params)
      _(response[0]).must_equal 200
      _(action.meeting).must_equal meeting
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, Minitest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }

    it 'is redirected' do
      action = Admin::Controllers::Meeting::Destroy.new(
        meeting_repo: nil,
        admin_history_repo: nil,
        authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
