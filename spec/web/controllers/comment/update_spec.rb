require_relative '../../../spec_helper'

describe Web::Controllers::Comment::Update do
  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]) }

    # TODO: during_meeting?サービスを実装してからテスト実装すること
    it 'is successful' do
      skip
      action = Web::Controllers::Comment::Update.new
      response = action.call(params)
      _(response[0]).must_equal 200
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, false), [nil]) }

    it 'is redirected' do
      action = Web::Controllers::Comment::Update.new(
        meeting_repo: nil, comment_repo: nil, vote_result_repo: nil, authenticator: authenticator
      )
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
