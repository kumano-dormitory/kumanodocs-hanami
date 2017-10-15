require 'spec_helper'
require_relative '../../../../../apps/admin/controllers/meeting/article/show'

describe Admin::Controllers::Meeting::Article::Show do
  let(:action) { Admin::Controllers::Meeting::Article::Show.new }
  let(:meeting_repo) { MeetingRepository.new }
  let(:article) { create(:article) }
  let(:meeting) { meeting_repo.find(article.meeting_id) }
  let(:params) { {meeting_id: article.meeting_id, id: article.id} }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200

    action.meeting.must_equal meeting
    action.article.must_equal article
  end
end
