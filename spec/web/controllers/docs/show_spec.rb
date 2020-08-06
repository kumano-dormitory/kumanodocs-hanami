require_relative '../../../spec_helper'

describe Web::Controllers::Docs::Show do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]) }
    let(:document_repo) { MiniTest::Mock.new.expect(:find_with_relations, document, [id]) }
    let(:document) { Document.new(id: id) }
    let(:id) { rand(1..10) }
    let(:params) { {id: id} }

    it 'is successful' do
      action = Web::Controllers::Docs::Show.new(
        document_repo: document_repo, authenticator: authenticator
      )
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.document).must_equal document
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) {
      Web::Controllers::Docs::Show.new(
        document_repo: nil, authenticator: authenticator
      )
    }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
