require_relative '../../../spec_helper'

describe Web::Controllers::Docs::Index do
  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]) }
    let(:document_repo) { Minitest::Mock.new.expect(:order_by_number, [document]) }
    let(:document) { Document.new(id: rand(1..10)) }
    let(:params) { Hash[] }

    it 'is successful' do
      action = Web::Controllers::Docs::Index.new(
        document_repo: document_repo, authenticator: authenticator
      )
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.documents).must_equal [document]
      _(document_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) {
      Web::Controllers::Docs::Index.new(
        document_repo: nil, authenticator: authenticator
      )
    }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
