require_relative '../../../spec_helper'

describe Web::Controllers::Docs::New do
  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]) }
    let(:user) { User.new(id: rand(1..100)) }
    let(:session) { {user_id: user.id} }
    let(:params_with_editor_session) { {'rack.session' => session} }
    let(:params_without_editor_session) { Hash[] }

    it 'is successful for logged in editor' do
      user_repo = Minitest::Mock.new.expect(:find, user, [user.id])
      action = Web::Controllers::Docs::New.new(
        user_repo: user_repo, authenticator: authenticator
      )
      response = action.call(params_with_editor_session)
      _(response[0]).must_equal 200
      _(action.user).must_equal user
      _(user_repo.verify).must_equal true
    end

    it 'is rejected for logged out editor' do
      action = Web::Controllers::Docs::New.new(
        user_repo: nil, authenticator: authenticator
      )
      response = action.call(params_without_editor_session)
      _(response[0]).must_equal 302
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) {
      Web::Controllers::Docs::New.new(
        user_repo: nil, authenticator: authenticator
      )
    }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
