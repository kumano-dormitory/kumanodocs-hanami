require 'spec_helper'
require_relative '../../../../apps/admin/controllers/meeting/index'

describe Admin::Controllers::Meeting::Index do
  let(:action) { Admin::Controllers::Meeting::Index.new }
  let(:meeting_repo) { MeetingRepository.new }
  let(:params) { Hash[] }

  it 'is successful' do
    _meetings = meeting_repo.desc_by_date
    response = action.call(params)
    response[0].must_equal 200

    action.meetings.must_equal _meetings
  end
end
