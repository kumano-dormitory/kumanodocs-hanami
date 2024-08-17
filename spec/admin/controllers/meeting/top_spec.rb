require_relative '../../../spec_helper'

describe Admin::Controllers::Meeting::Top do
  let(:action) { Admin::Controllers::Meeting::Top.new(authenticator: authenticator) }
  let(:params) { Hash[] }

  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]) }
    it 'is successful' do
      response = action.call(params)
      _(response[0]).must_equal 200
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, Minitest::Mock.new.expect(:user, nil), [nil]) }
    it 'is redirected' do
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
