require 'spec_helper'
require_relative '../../../../apps/admin/controllers/meeting/show'

describe Admin::Controllers::Meeting::Show do
  let(:action) { Admin::Controllers::Meeting::Show.new }
  let(:meeting_repo) { MeetingRepository.new }
  let(:meeting) { create(:meeting) }
  let(:params) { {id: meeting.id} }

  it 'is successful' do
    _meeting = meeting_repo.find(meeting.id)
    response = action.call(params)
    response[0].must_equal 200

    action.meeting.must_equal _meeting
  end
end
