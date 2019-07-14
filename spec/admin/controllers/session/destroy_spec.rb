require 'spec_helper'

describe Admin::Controllers::Sessions::Destroy do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]) }
    let(:params) { {} }

    it 'is successful destroy session' do
      admin_history_repo = MiniTest::Mock.new.expect(:add, nil, [:sessions_destroy, String])
      action = Admin::Controllers::Sessions::Destroy.new(
        admin_history_repo: admin_history_repo,
        authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 302
      admin_history_repo.verify.must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Sessions::Destroy.new(
        admin_history_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 302
    end
  end

end
