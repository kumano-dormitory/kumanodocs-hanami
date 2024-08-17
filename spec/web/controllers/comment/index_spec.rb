require_relative '../../../spec_helper'

describe Web::Controllers::Comment::Index do
  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]) }
    let(:meeting) { Meeting.new(id: rand(1..50)) }
    let(:block) { Block.new(id: rand(1..9)) }
    let(:blocks_with_count) {[
      { id: block.id, comment_count: rand(1..10), vote_result_count: rand(1..10) }
    ]}
    let(:params) { {meeting_id: meeting.id} }

    it 'is successful' do
      meeting_repo = Minitest::Mock.new.expect(:find, meeting, [meeting.id])
      block_repo = Minitest::Mock.new.expect(:by_meeting_with_comment_vote_count, blocks_with_count, [meeting.id])
      action = Web::Controllers::Comment::Index.new(
        meeting_repo: meeting_repo, block_repo: block_repo, authenticator: authenticator
      )
      response = action.call(params)

      _(response[0]).must_equal 200
      _(action.meeting).must_equal meeting
      _(action.blocks).must_equal blocks_with_count
      _(meeting_repo.verify).must_equal true
      _(block_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, false), [nil]) }

    it 'is redirected' do
      action = Web::Controllers::Comment::Index.new(
        meeting_repo: nil, block_repo: nil, authenticator: authenticator
      )
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
