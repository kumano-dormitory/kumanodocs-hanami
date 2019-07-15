require 'spec_helper'
require_relative '../../../../apps/admin/controllers/article_status/edit'

describe Admin::Controllers::ArticleStatus::Edit do
  describe 'when user is logged in' do
    let(:meeting) { Meeting.new(id: rand(1..50)) }
    let(:past_meeting) { Meeting.new(id: rand(1..50)) }
    let(:article) { Article.new(id: rand(1..100), meeting_id: meeting.id) }
    let(:params) { { id: meeting.id } }
    let(:params_for_articles) { {id: meeting.id, articles: true} }
    let(:params_for_comments) { {id: meeting.id, comments: true} }

    it 'is successful for select meeting' do
      action = Admin::Controllers::Meeting::Download.new(
        meeting_repo: MiniTest::Mock.new.expect(:desc_by_date, [meeting], [Hash]),
        article_repo: nil, block_repo: nil, comment_repo: nil, admin_history_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call({})
      response[0].must_equal 200
      action.meetings.must_equal [meeting]
      action.view_type.must_equal :meetings
    end

    it 'is successful for select download type' do
      action = Admin::Controllers::Meeting::Download.new(
        meeting_repo: MiniTest::Mock.new.expect(:find, meeting, [meeting.id]),
        article_repo: nil, block_repo: nil, comment_repo: nil, admin_history_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(params)
      response[0].must_equal 200
      action.meeting.must_equal meeting
      action.view_type.must_equal :meeting
    end

    it 'is successful for download articles pdf' do
      # TODO: PDF生成をサービスとして実装したあとにこのテストを修正すること
      skip
      article_repo = MiniTest::Mock.new.expect(:for_download, [article], [meeting, Hash])
                                       .expect(:update_printed, nil, [{id: article.id, printed: true}])
      action = Admin::Controllers::Meeting::Download.new(
        meeting_repo: MiniTest::Mock.new.expect(:find, meeting, [meeting.id])
                                        .expect(:find_past_meeting, past_meeting, [meeting.id]),
        article_repo: article_repo,
        block_repo: nil, comment_repo: nil,
        admin_history_repo: MiniTest::Mock.new.expect(:add, nil, [:meeting_download, String]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(params_for_articles)
      response[0].must_equal 200
      action.format.must_equal :pdf
      article_repo.verify.must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Meeting::Download.new(
        meeting_repo: nil, article_repo: nil, block_repo: nil, comment_repo: nil,
        admin_history_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 302
    end
  end
end
