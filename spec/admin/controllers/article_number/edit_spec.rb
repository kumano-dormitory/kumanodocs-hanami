require 'spec_helper'
require_relative '../../../../apps/admin/controllers/article_number/edit'

describe Admin::Controllers::ArticleNumber::Edit do
  let(:action) { Admin::Controllers::ArticleNumber::Edit.new }
  let(:meeting_repo) { MeetingRepository.new }
  let(:article) { create(:article) }
  let(:params) { {id: article.meeting_id} }

  it 'is successful' do
    meeting = meeting_repo.find_with_articles(article.meeting_id)
    response = action.call(params)
    response[0].must_equal 200

    action.meeting.must_equal meeting
  end
end
