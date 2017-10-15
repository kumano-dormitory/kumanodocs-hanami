require 'spec_helper'
require_relative '../../../../apps/admin/controllers/article_status/edit'

describe Admin::Controllers::ArticleStatus::Edit do
  let(:action) { Admin::Controllers::ArticleStatus::Edit.new }
  let(:meeting_repo) { MeetingRepository.new }
  let(:article) { create(:article) }

  it 'is successful' do
    _meeting = meeting_repo.find_with_articles(article.meeting_id)

    response = action.call(id: article.meeting_id)
    response[0].must_equal 200

    action.meeting.must_equal _meeting
  end
end
