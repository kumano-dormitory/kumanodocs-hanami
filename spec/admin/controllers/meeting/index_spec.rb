require 'spec_helper'
require_relative '../../../../apps/admin/controllers/meeting/index'

describe Admin::Controllers::Meeting::Index do
  let(:user) { create(:user) }
  let(:params) { { } }
  let(:meetings) { [Meeting.new(id: rand(1..10))] }

  it 'is successful' do
    action = Admin::Controllers::Meeting::Index.new(
      authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, true), [nil]),
      meeting_repo: MiniTest::Mock.new.expect(:desc_by_date, meetings, [{limit: 15, offset: 0}]),
    )
    response = action.call(params)
    response[0].must_equal 200
    action.meetings.must_equal meetings
    action.page.must_equal 1
  end

  it 'is redirected' do
    action = Admin::Controllers::Meeting::Index.new(
      authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                       .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]),
      meeting_repo: nil,
    )
    response = action.call(params)
    response[0].must_equal 302
  end
end
