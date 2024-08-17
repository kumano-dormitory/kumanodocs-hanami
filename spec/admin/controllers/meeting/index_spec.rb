require 'spec_helper'
require_relative '../../../../apps/admin/controllers/meeting/index'

describe Admin::Controllers::Meeting::Index do
  let(:user) { create(:user) }
  let(:params) { { } }
  let(:meetings) { [Meeting.new(id: rand(1..10))] }

  it 'is successful' do
    action = Admin::Controllers::Meeting::Index.new(
      authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, true), [nil]),
      meeting_repo: Minitest::Mock.new.expect(:desc_by_date, meetings, [{limit: 15, offset: 0}]),
    )
    response = action.call(params)
    _(response[0]).must_equal 200
    _(action.meetings).must_equal meetings
    _(action.page).must_equal 1
  end

  it 'is redirected' do
    action = Admin::Controllers::Meeting::Index.new(
      authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, nil), [nil])
                                       .expect(:call, Minitest::Mock.new.expect(:user, nil), [nil]),
      meeting_repo: nil,
    )
    response = action.call(params)
    _(response[0]).must_equal 302
  end
end
