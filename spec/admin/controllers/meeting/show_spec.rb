require 'spec_helper'
require_relative '../../../../apps/admin/controllers/meeting/show'

describe Admin::Controllers::Meeting::Show do
  let(:id) { rand(1..100) }
  let(:meeting) { Meeting.new(id: id) }
  let(:params) { {id: id} }

  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]) }
    it 'is successful' do
      action = Admin::Controllers::Meeting::Show.new(
        meeting_repo: Minitest::Mock.new.expect(:find, meeting, [id]),
        authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.meeting).must_equal meeting
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, Minitest::Mock.new.expect(:user, nil), [nil]) }
    it 'is redirected' do
      action = Admin::Controllers::Meeting::Show.new(
        meeting_repo: nil,
        authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
