require_relative '../../../spec_helper'

describe Web::Controllers::Docs::Edit do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]) }
    let(:user) { User.new(id: rand(1..100), authority: 1) }
    let(:invalid_user) { User.new(id: rand(101..200), authority: 1) }
    let(:document) { Document.new(id: rand(1..100), user_id: user.id) }
    let(:session) { {user_id: user.id} }
    let(:params_with_editor_session) { {id: document.id, 'rack.session' => session} }
    let(:params_with_invalid_editor_session) { {id: document.id, 'rack.session' => {user_id: invalid_user.id}} }
    let(:params_without_editor_session) { {id: document.id} }

    it 'is successful for logged in valid editor' do
      user_repo = MiniTest::Mock.new.expect(:find, user, [user.id])
      document_repo = MiniTest::Mock.new.expect(:find_with_relations, document, [document.id])
      action = Web::Controllers::Docs::Edit.new(
        document_repo: document_repo, user_repo: user_repo, authenticator: authenticator
      )
      response = action.call(params_with_editor_session)
      _(response[0]).must_equal 200
      _(action.document).must_equal document
      _(user_repo.verify).must_equal true
      _(document_repo.verify).must_equal true
    end

    it 'is rejected for logged in invalid editor' do
      user_repo = MiniTest::Mock.new.expect(:find, invalid_user, [invalid_user.id])
      document_repo = MiniTest::Mock.new.expect(:find_with_relations, document, [document.id])
      action = Web::Controllers::Docs::Edit.new(
        document_repo: document_repo, user_repo: user_repo, authenticator: authenticator
      )
      response = action.call(params_with_invalid_editor_session)
      _(response[0]).must_equal 302
      _(user_repo.verify).must_equal true
      _(document_repo.verify).must_equal true
    end

    it 'is rejected for logged out editor' do
      action = Web::Controllers::Docs::Edit.new(
        document_repo: nil, user_repo: nil, authenticator: authenticator
      )
      response = action.call(params_without_editor_session)
      _(response[0]).must_equal 302
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) {
      Web::Controllers::Docs::Edit.new(
        document_repo: nil, user_repo: nil, authenticator: authenticator
      )
    }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
