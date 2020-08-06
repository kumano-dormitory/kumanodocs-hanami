require_relative '../../../spec_helper'

describe Admin::Controllers::Docs::Create do
  let(:document) { Document.new(id: rand(1..10), title: Faker::Book.title, type: 0, body: Faker::Lorem.paragraphs.join) }

  describe 'when user is logged in' do
    describe 'user authority is 1 (documents editor)' do
      let(:user) { User.new(id: rand(1..100), authority: 1) }
      let(:user_repo) { MiniTest::Mock.new.expect(:by_authority, [user], [1])
                          .expect(:find, user, [user.id])
      }
      let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]) }
      let(:props) {{
        title: document.title, user_id: user.id, type: document.type, body: document.body
        }}
      let(:params) {{
        document: {
          title: document.title,
          user_id: user.id,
          type: document.type,
          body: document.body
        }
      }}
      let(:invalid_params) {{
        document: {
          titile: document.title, user_id: user.id
        }
      }}

      it 'is successful create doc' do
        document_repo = MiniTest::Mock.new.expect(:create, document, [props])
        action = Admin::Controllers::Docs::Create.new(
          document_repo: document_repo, user_repo: user_repo, authenticator: authenticator
        )
        response = action.call(params)
        _(response[0]).must_equal 302
        _(document_repo.verify).must_equal true
        _(user_repo.verify).must_equal true
        _(authenticator.verify).must_equal true
      end

      it 'is invalid params' do
        document_repo = nil
        action = Admin::Controllers::Docs::Create.new(
          document_repo: document_repo, user_repo: user_repo, authenticator: authenticator
        )
        response = action.call(invalid_params)
        _(response[0]).must_equal 200
        _(action.users).must_equal [user]
        _(user_repo.verify).must_equal true
        _(authenticator.verify).must_equal true
      end
    end

    describe 'user authority is not 1' do
      let(:action) { Admin::Controllers::Docs::Create.new(
          document_repo: document_repo, user_repo: user_repo, authenticator: authenticator
        )
      }
      let(:user) { User.new(id: rand(1..100), authority: [0, 2, 3].sample) }
      let(:document_repo) { nil }
      let(:user_repo) { MiniTest::Mock.new.expect(:by_authority, [user], [1])
                          .expect(:find, user, [user.id])
      }
      let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]) }
      let(:params) {{
        document: {
          title: document.title,
          user_id: user.id,
          type: document.type,
          body: document.body
        }
      }}

      it 'is redirected' do
        response = action.call(params)
        _(response[0]).must_equal 302
        _(user_repo.verify).must_equal true
        _(authenticator.verify).must_equal true
      end
    end
  end

  describe 'when user is not logged in' do
    let(:action) { Admin::Controllers::Docs::Create.new(
        document_repo: document_repo, user_repo: user_repo, authenticator: authenticator
      )
    }
    let(:document_repo) { nil }
    let(:user_repo) { nil }
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }

    it 'is redirected' do
      response = action.call(params)
      _(response[0]).must_equal 302
      _(authenticator.verify).must_equal true
    end
  end
end
