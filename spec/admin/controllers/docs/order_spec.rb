require_relative '../../../spec_helper'

describe Admin::Controllers::Docs::Order do
  let(:action) { Admin::Controllers::Docs::Order.new(
    document_repo: document_repo, authenticator: authenticator
  ) }
  let(:document) { Document.new(id: rand(1..10)) }
  let(:params) { Hash[] }

  describe 'when user is logged in' do
    let(:document_repo) { MiniTest::Mock.new.expect(:order_by_number, [document]) }
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]) }
    
    it 'is successful' do
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.documents).must_equal [document]
      _(document_repo.verify).must_equal true
      _(authenticator.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:document_repo) { nil }
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    it 'is redirected' do
      response = action.call(params)
      _(response[0]).must_equal 302
      _(authenticator.verify).must_equal true
    end
  end
end
