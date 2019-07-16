require_relative '../../../spec_helper'

describe Web::Controllers::Login::Show do
  let(:params) { {} }
  it 'is successful' do
    action = Web::Controllers::Login::Show.new(authenticator: nil)
    response = action.call(params)
    response[0].must_equal 200
    action.standalone.must_equal false
  end

  let(:params_pwa) { {standalone: true} }
  it 'is redirected when logged in from pwa' do
    authenticator = MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil])
    action = Web::Controllers::Login::Show.new(authenticator: authenticator)
    response = action.call(params_pwa)

    response[0].must_equal 302
    authenticator.verify.must_equal true
  end
end
