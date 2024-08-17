require_relative '../../../spec_helper'

describe Web::Controllers::Docs::Destroy do
  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]) }
    let(:user) { User.new(id: rand(1..100), authority: 1) }
    let(:invalid_user) { User.new(id: rand(101..200), authority: 1) }
    let(:document) { Document.new(id: rand(1..100), user_id: user.id) }
    let(:session) { {user_id: user.id} }
    let(:params_with_editor_session) {{
      'rack.session' => session,
      id: document.id
    }}
    let(:params_with_invalid_editor_session) {{
      'rack.session' => {user_id: invalid_user.id},
      id: document.id
    }}
    let(:params_without_editor_session) { Hash[] }

    it 'is successful for logged in editor' do
      user_repo = Minitest::Mock.new.expect(:find, user, [user.id])
      document_repo = Minitest::Mock.new.expect(:find, document, [document.id])
        .expect(:delete, nil, [document.id])
      action = Web::Controllers::Docs::Destroy.new(
        document_repo: document_repo, user_repo: user_repo, authenticator: authenticator
      )
      params = params_with_editor_session.merge({document: {confirm: true}})
      response = action.call(params)
      _(response[0]).must_equal 302
      _(user_repo.verify).must_equal true
      _(document_repo.verify).must_equal true
    end

    it 'displays confirmation page' do
      user_repo = Minitest::Mock.new.expect(:find, user, [user.id])
      document_repo = Minitest::Mock.new.expect(:find, document, [document.id])
      action = Web::Controllers::Docs::Destroy.new(
        document_repo: document_repo, user_repo: user_repo, authenticator: authenticator
      )
      response = action.call(params_with_editor_session)
      _(response[0]).must_equal 200
      _(action.document).must_equal document
      _(user_repo.verify).must_equal true
      _(document_repo.verify).must_equal true
    end

    it 'is rejected for invalid editor' do
      user_repo = Minitest::Mock.new.expect(:find, invalid_user, [invalid_user.id])
      document_repo = Minitest::Mock.new.expect(:find, document, [document.id])
      action = Web::Controllers::Docs::Destroy.new(
        document_repo: document_repo, user_repo: user_repo, authenticator: authenticator
      )
      response = action.call(params_with_invalid_editor_session)
      _(response[0]).must_equal 302
      _(user_repo.verify).must_equal true
      _(document_repo.verify).must_equal true
    end

    it 'is rejected for logged out editor' do
      action = Web::Controllers::Docs::Destroy.new(
        document_repo: nil, user_repo: nil, authenticator: authenticator
      )
      response = action.call(params_without_editor_session)
      _(response[0]).must_equal 302
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) {
      Web::Controllers::Docs::Destroy.new(
        document_repo: nil, user_repo: nil, authenticator: authenticator
      )
    }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
