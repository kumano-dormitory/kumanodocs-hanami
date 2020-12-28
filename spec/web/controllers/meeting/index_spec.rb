require_relative '../../../spec_helper'

describe Web::Controllers::Meeting::Index do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]) }
    let(:meetings) { [Meeting.new(id: rand(1..5))] }
    let(:params) { {} }

    it 'is successful' do
      meeting_repo = MiniTest::Mock.new.expect(:desc_by_date, meetings, [Hash]).expect(:count, 1)
      action = Web::Controllers::Meeting::Index.new(meeting_repo: meeting_repo, authenticator: authenticator)
      response = action.call(params)

      _(response[0]).must_equal 200
      _(action.meetings).must_equal meetings
      _(meeting_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) { Web::Controllers::Meeting::Index.new(authenticator: authenticator) }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
