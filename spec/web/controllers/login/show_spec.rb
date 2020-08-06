require_relative '../../../spec_helper'

describe Web::Controllers::Login::Show do
  let(:params) { {} }
  it 'is successful' do
    action = Web::Controllers::Login::Show.new(authenticator: nil)
    response = action.call(params)
    _(response[0]).must_equal 200
    _(action.standalone).must_equal false
  end

  let(:params_pwa) { {standalone: true} }
  it 'is redirected when logged in from pwa' do
    authenticator = MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil])
    action = Web::Controllers::Login::Show.new(authenticator: authenticator)
    response = action.call(params_pwa)

    _(response[0]).must_equal 302
    _(authenticator.verify).must_equal true
  end
end
