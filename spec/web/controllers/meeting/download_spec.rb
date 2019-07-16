require_relative '../../../spec_helper'

describe Web::Controllers::Meeting::Download do
  describe 'when user is logged in' do
    let(:meeting) { Meeting.new(id: rand(1..5)) }
    let(:meetings) { [meeting] }
    let(:params) { {id: meeting.id} }

    # TODO: PDF生成サービスを実装後、テストを実装すること
    it 'is successful download meeting' do
      skip
      action = Web::Controllers::Meeting::Download.new(
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      response = action.call(params)

      response[0].must_equal 200
      response[1]['Content-Type'].must_match 'application/pdf'
    end

    it 'is successful display select meeting page' do
      meeting_repo = MiniTest::Mock.new.expect(:desc_by_date, meetings, [Hash])
      action = Web::Controllers::Meeting::Download.new(
        meeting_repo: meeting_repo, article_repo: nil, comment_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      response = action.call({})

      response[0].must_equal 200
      action.meetings.must_equal meetings
      meeting_repo.verify.must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }

    it 'is redirected' do
      action = Web::Controllers::Meeting::Download.new(
        meeting_repo: nil, article_repo: nil, comment_repo: nil, authenticator: authenticator
      )
      response = action.call({})
      response[0].must_equal 302
    end
  end
end
