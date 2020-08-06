require_relative '../../../spec_helper'

describe Admin::Controllers::Docs::Update do
  let(:document) { Document.new(id: rand(1..10), title: Faker::Book.title, type: 0, body: Faker::Lorem.paragraphs.join, user: user, user_id: user.id) }

  describe 'when user is logged in' do
    describe 'user authority is 1 (documents editor)' do
      let(:user) { User.new(id: rand(1..100), authority: 1) }
      let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]) }
      let(:props) {{
        title: document.title, type: document.type, body: document.body
      }}
      let(:params) {{
        id: document.id,
        document: {
          title: document.title,
          user_id: user.id,
          type: document.type,
          body: document.body
        }
      }}
      let(:invalid_params) {{
        id: document.id,
        document: {
          titile: document.title, user_id: user.id
        }
      }}

      it 'is successful update doc' do
        document_repo = MiniTest::Mock.new.expect(:find_with_relations, document, [document.id])
          .expect(:update, nil, [document.id, props])
        action = Admin::Controllers::Docs::Update.new(
          document_repo: document_repo, authenticator: authenticator
        )
        response = action.call(params)
        _(response[0]).must_equal 302
        _(document_repo.verify).must_equal true
        _(authenticator.verify).must_equal true
      end

      it 'is invalid params' do
        document_repo = MiniTest::Mock.new.expect(:find_with_relations, document, [document.id])
        action = Admin::Controllers::Docs::Update.new(
          document_repo: document_repo, authenticator: authenticator
        )
        response = action.call(invalid_params)
        _(response[0]).must_equal 422
        _(action.document).must_equal document
        _(document_repo.verify).must_equal true
        _(authenticator.verify).must_equal true
      end
    end

    describe 'user authority is not 1' do
      let(:action) { Admin::Controllers::Docs::Update.new(
          document_repo: document_repo, authenticator: authenticator
        )
      }
      let(:user) { User.new(id: rand(1..100), authority: [0, 2, 3].sample) }
      let(:document_repo) { MiniTest::Mock.new.expect(:find_with_relations, document, [document.id]) }
      let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]) }
      let(:params) {{ id: document.id, document: {} }}

      it 'is redirected' do
        response = action.call(params)
        _(response[0]).must_equal 302
        _(document_repo.verify).must_equal true
        _(authenticator.verify).must_equal true
      end
    end
  end

  describe 'when user is not logged in' do
    let(:document_repo) { nil }
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:action) { Admin::Controllers::Docs::Update.new(
      document_repo: document_repo, authenticator: authenticator
    )}
    let(:params) {{id: rand(1..100), document: {}}}

    it 'is redirected' do
      response = action.call(params)
      _(response[0]).must_equal 302
      _(authenticator.verify).must_equal true
    end
  end
end
