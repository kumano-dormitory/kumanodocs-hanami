require_relative '../../../spec_helper'

describe Admin::Controllers::Docs::Destroy do
  let(:document) { Document.new(id: rand(1..10)) }
  let(:params) { {id: document.id} }
  let(:params_with_confirm) { {id: document.id, document: {confirm: true} } }

  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]) }

    it 'is successful confirm' do
      document_repo = Minitest::Mock.new.expect(:find_with_relations, document, [params[:id]])
      action = Admin::Controllers::Docs::Destroy.new(
          document_repo: document_repo, authenticator: authenticator
      )

      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.document).must_equal document
      _(document_repo.verify).must_equal true
      _(authenticator.verify).must_equal true
    end

    it 'is successful confirm' do
      document_repo = Minitest::Mock.new.expect(:find_with_relations, document, [params[:id]])
        .expect(:delete, nil, [document.id])
      action = Admin::Controllers::Docs::Destroy.new(
          document_repo: document_repo, authenticator: authenticator
      )

      response = action.call(params_with_confirm)
      _(response[0]).must_equal 302
      _(document_repo.verify).must_equal true
      _(authenticator.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:document_repo) { nil }
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, Minitest::Mock.new.expect(:user, nil), [nil]) }
    let(:action) {
      Admin::Controllers::Docs::Destroy.new(
          document_repo: document_repo, authenticator: authenticator
      )
    }

    it 'is redirected' do
      response = action.call(params)
      _(response[0]).must_equal 302
      _(authenticator.verify).must_equal true
    end
  end
end
