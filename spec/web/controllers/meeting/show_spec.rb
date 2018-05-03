require_relative '../../../spec_helper'

describe Web::Controllers::Meeting::Show do
  let(:articles) { [Article.new(id: rand(1..5))] }
  let(:meeting) { Meeting.new(id: rand(1..5), articles: articles) }
  let(:params) { {id: meeting.id} }

  it 'is successful' do
    action = Web::Controllers::Meeting::Show.new(
      meeting_repo: MiniTest::Mock.new.expect(:find_with_articles, meeting, [meeting.id])
    )
    response = action.call(params)
    response[0].must_equal 200
    action.meeting.must_equal meeting
  end
end
