require_relative '../../../spec_helper'

describe Web::Controllers::Docs::Download do
  let(:action) { Web::Controllers::Docs::Download.new }
  let(:params) { Hash[] }

  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]) }
    let(:document_repo) { Minitest::Mock.new.expect(:find, document, [document.id]) }
    let(:document) { Document.new(id: rand(1..10)) }
    let(:params) { {id: document.id} }

    it 'is successful' do
      skip
      action = Web::Controllers::Docs::Download.new(
        document_repo: document_repo, authenticator: authenticator
      )
      response = action.call(params)
      _(response[0]).must_equal 200
      _(document_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) {
      Web::Controllers::Docs::Download.new(
        document_repo: nil, authenticator: authenticator
      )
    }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
