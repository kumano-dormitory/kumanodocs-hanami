require 'spec_helper'
require_relative '../../../../apps/admin/controllers/article_status/update'

describe Admin::Controllers::ArticleStatus::Update do
  let(:articles_status) {
    (1..5).map{ |id| {'article_id' => id, 'checked' => [true, nil].sample, 'printed' => [true, nil].sample} }
  }
  let(:params) {
    {
      meeting: { articles: articles_status },
      id: rand(1..5)
    }
  }

  it 'is successful' do
    action = Admin::Controllers:: ArticleStatus::Update.new(
      article_repo: MiniTest::Mock.new.expect(:update_status, nil, [articles_status])
    )

    response = action.call(params)
    response[0].must_equal 302
  end

  it 'is rejected' do
    meeting = Meeting.new(id: params[:id])
    action = Admin::Controllers::ArticleStatus::Update.new(
      meeting_repo: MiniTest::Mock.new.expect(:find_with_articles, meeting, [params[:id]])
    )

    response = action.call(id: params[:id])
    response[0].must_equal 422
    action.meeting.must_equal meeting
  end
end
