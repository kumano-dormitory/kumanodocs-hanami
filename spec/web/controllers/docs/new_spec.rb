require_relative '../../../spec_helper'

describe Web::Controllers::Docs::New do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]) }
    let(:user) { User.new(id: rand(1..100)) }
    let(:session) { {user_id: user.id} }
    let(:params_with_editor_session) { {'rack.session' => session} }
    let(:params_without_editor_session) { Hash[] }

    it 'is successful for logged in editor' do
      user_repo = MiniTest::Mock.new.expect(:find, user, [user.id])
      action = Web::Controllers::Docs::New.new(
        user_repo: user_repo, authenticator: authenticator
      )
      response = action.call(params_with_editor_session)
      response[0].must_equal 200
      action.user.must_equal user
      user_repo.verify.must_equal true
    end

    it 'is rejected for logged out editor' do
      action = Web::Controllers::Docs::New.new(
        user_repo: nil, authenticator: authenticator
      )
      response = action.call(params_without_editor_session)
      response[0].must_equal 302
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) {
      Web::Controllers::Docs::New.new(
        user_repo: nil, authenticator: authenticator
      )
    }

    it 'is redirected' do
      response = action.call({})
      response[0].must_equal 302
    end
  end
end
