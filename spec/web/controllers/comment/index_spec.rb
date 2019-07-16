require_relative '../../../spec_helper'

describe Web::Controllers::Comment::Index do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]) }
    let(:meeting) { Meeting.new(id: rand(1..50)) }
    let(:block) { Block.new(id: rand(1..9)) }
    let(:blocks_with_count) {[
      { id: block.id, comment_count: rand(1..10), vote_result_count: rand(1..10) }
    ]}
    let(:params) { {meeting_id: meeting.id} }

    it 'is successful' do
      meeting_repo = MiniTest::Mock.new.expect(:find, meeting, [meeting.id])
      block_repo = MiniTest::Mock.new.expect(:by_meeting_with_comment_vote_count, blocks_with_count, [meeting.id])
      action = Web::Controllers::Comment::Index.new(
        meeting_repo: meeting_repo, block_repo: block_repo, authenticator: authenticator
      )
      response = action.call(params)

      response[0].must_equal 200
      action.meeting.must_equal meeting
      action.blocks.must_equal blocks_with_count
      meeting_repo.verify.must_equal true
      block_repo.verify.must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }

    it 'is redirected' do
      action = Web::Controllers::Comment::Index.new(
        meeting_repo: nil, block_repo: nil, authenticator: authenticator
      )
      response = action.call({})
      response[0].must_equal 302
    end
  end
end
