require_relative '../../../../spec_helper'

describe Web::Controllers::Docs::Login::New do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]) }
    let(:params) { Hash[] }

    it 'is successful' do
      action = Web::Controllers::Docs::Login::New.new(authenticator: authenticator)
      response = action.call(params)
      _(response[0]).must_equal 200
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) { Web::Controllers::Docs::Login::New.new(authenticator: authenticator) }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
