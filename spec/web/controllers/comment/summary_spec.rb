require_relative '../../../spec_helper'

describe Web::Controllers::Comment::Summary do
  let(:action) { Web::Controllers::Comment::Summary.new }

  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]) }
    let(:meeting) { Meeting.new(id: rand(1..100), date: Date.today) }
    let(:article) { Article.new(id: rand(1..100)) }
    let(:comment) { {id: rand(1..100), article_id: article.id} }
    let(:msg) { {id: rand(1..100), comment_id: comment[:id]} }
    let(:params) { Hash[] }

    it 'is successful' do
      meeting_repo = MiniTest::Mock.new.expect(:desc_by_date, [meeting], [{limit: 15}])
      comment_repo = MiniTest::Mock.new.expect(:by_meeting, [comment], [meeting.id])
      message_repo = MiniTest::Mock.new.expect(:by_meeting, [msg], [meeting.id])
      action = Web::Controllers::Comment::Summary.new(
        meeting_repo: meeting_repo, comment_repo: comment_repo,
        message_repo: message_repo, authenticator: authenticator
      )
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.meetings).must_equal [meeting]
      _(action.meeting).must_equal meeting
      _(action.comments).must_equal ({comment[:article_id] => [comment]})
      _(action.messages).must_equal ({msg[:comment_id] => [msg]})
      _(action.max_page).must_equal 0
      _(action.page).must_equal 0
      _(meeting_repo.verify).must_equal true
      _(comment_repo.verify).must_equal true
      _(message_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) {
      Web::Controllers::Comment::Summary.new(
        meeting_repo: nil, comment_repo: nil,
        message_repo: nil, authenticator: authenticator
      )
    }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
