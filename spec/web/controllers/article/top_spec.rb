require_relative '../../../spec_helper'

describe Web::Controllers::Article::Top do
  describe 'when user is logged in' do
    let(:meeting) { Meeting.new(id: rand(1..50)) }
    let(:blocks) { [Block.new(id: rand(1..9))] }
    let(:params) { {} }

    it 'is successful' do
      action = Web::Controllers::Article::Top.new(
        meeting_repo: MiniTest::Mock.new.expect(:find_most_recent, meeting, []),
        block_repo: MiniTest::Mock.new.expect(:by_meeting_with_comment_vote_count, blocks, [meeting.id]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.next_meeting).must_equal meeting
      _(action.save_token).must_equal false
    end

    # TODO: during_meeting? メソッドをサービスとして定義したあとに会議中かどうかでテストを分ける

    let(:params_pwa) { {loggedin: true} }
    it 'is successful for PWA' do
      action = Web::Controllers::Article::Top.new(
        meeting_repo: MiniTest::Mock.new.expect(:find_most_recent, meeting, []),
        block_repo: MiniTest::Mock.new.expect(:by_meeting_with_comment_vote_count, blocks, [meeting.id]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      response = action.call(params_pwa)
      _(response[0]).must_equal 200
      _(action.next_meeting).must_equal meeting
      _(action.save_token).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    it 'is redirected' do
      action = Web::Controllers::Article::Top.new(
        meeting_repo: nil, block_repo: nil, authenticator: authenticator
      )
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
