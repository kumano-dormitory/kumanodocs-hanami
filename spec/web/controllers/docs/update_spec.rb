require_relative '../../../spec_helper'

describe Web::Controllers::Docs::Update do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]) }
    let(:user) { User.new(id: rand(1..100), authority: 1) }
    let(:session) { {user_id: user.id} }
    let(:document) { Document.new(id: rand(1..100), title: Faker::Book.title, user_id: user.id, type: 0, body: Faker::Lorem.paragraphs.join) }
    let(:document_props) { {
      title: document.title,
      type: document.type,
      body: document.body
    } }
    let(:params_with_editor_session) { {
      'rack.session' => session,
      id: document.id,
      document: document_props.merge({user_id: document.user_id})
    } }
    let(:invalid_params_with_editor_session) { {
      'rack.session' => session,
      id: document.id,
      document: document_props
    } }
    let(:params_without_editor_session) { Hash[] }

    it 'is successful for logged in editor' do
      user_repo = MiniTest::Mock.new.expect(:find, user, [user.id])
      document_repo = MiniTest::Mock.new.expect(:find, document, [document.id])
        .expect(:update, nil, [document.id, document_props])
      action = Web::Controllers::Docs::Update.new(
        document_repo: document_repo, user_repo: user_repo, authenticator: authenticator
      )
      response = action.call(params_with_editor_session)
      response[0].must_equal 302
      user_repo.verify.must_equal true
      document_repo.verify.must_equal true
    end

    it 'displays form again' do
      user_repo = MiniTest::Mock.new.expect(:find, user, [user.id])
      document_repo = MiniTest::Mock.new.expect(:find, document, [document.id])
      action = Web::Controllers::Docs::Update.new(
        document_repo: document_repo, user_repo: user_repo, authenticator: authenticator
      )
      response = action.call(invalid_params_with_editor_session)
      response[0].must_equal 422
      action.document.must_equal document
      user_repo.verify.must_equal true
      document_repo.verify.must_equal true
    end

    it 'is rejected for logged out editor' do
      action = Web::Controllers::Docs::Update.new(
        document_repo: nil, user_repo: nil, authenticator: authenticator
      )
      response = action.call(params_without_editor_session)
      response[0].must_equal 302
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) {
      Web::Controllers::Docs::Update.new(
        document_repo: nil, user_repo: nil, authenticator: authenticator
      )
    }

    it 'is redirected' do
      response = action.call({})
      response[0].must_equal 302
    end
  end
end
