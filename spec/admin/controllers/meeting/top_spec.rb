require_relative '../../../spec_helper'

describe Admin::Controllers::Meeting::Top do
  let(:action) { Admin::Controllers::Meeting::Top.new(authenticator: authenticator) }
  let(:params) { Hash[] }

  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]) }
    it 'is successful' do
      response = action.call(params)
      response[0].must_equal 200
    end
  end

  describe 'when use is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    it 'is redirected' do
      response = action.call(params)
      response[0].must_equal 302
    end
  end
end
