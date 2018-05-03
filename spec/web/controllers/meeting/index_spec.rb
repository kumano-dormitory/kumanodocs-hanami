require_relative '../../../spec_helper'

describe Web::Controllers::Meeting::Index do
  let(:meetings) { [Meeting.new(id: rand(1..5))] }
  let(:params) { Hash[] }

  it 'is successful' do
    action = Web::Controllers::Meeting::Index.new(
      meeting_repo: MiniTest::Mock.new.expect(:desc_by_date, meetings)
    )
    response = action.call(params)

    response[0].must_equal 200
    action.meetings.must_equal meetings
  end
end
