require_relative '../../../spec_helper'

describe Admin::Controllers::Docs::UpdateOrder do
  let(:document1) { Document.new(id: rand(1..10)) }
  let(:document2) { Document.new(id: rand(11..20)) }
  let(:document3) { Document.new(id: rand(21..30)) }

  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]) }
    let(:documents) { [document1, document2, document3] }
    let(:props) { params[:document][:order] }
    let(:params) {{
      document: {
        order: [
          {'number' => "1", 'document_id' => "#{document1.id}"},
          {'number' => "2", 'document_id' => "#{document2.id}"},
          {'number' => "3", 'document_id' => "#{document3.id}"}
        ].shuffle
      }
    }}
    let(:invalid_params) {{
      document: {
        order: [
          {'number' => "10", 'document_id' => "#{document1.id}"},
          {'number' => "2", 'document_id' => "#{document2.id}"},
          {'number' => "8", 'document_id' => "#{document3.id}"}
        ].shuffle
      }
    }}

    it 'is successful' do
      document_repo = Minitest::Mock.new.expect(:update_number, nil, [props])
      action = Admin::Controllers::Docs::UpdateOrder.new(
        document_repo: document_repo, authenticator: authenticator
      )
      response = action.call(params)
      _(response[0]).must_equal 302
      _(document_repo.verify).must_equal true
      _(authenticator.verify).must_equal true
    end

    it 'is rejected' do
      document_repo = Minitest::Mock.new.expect(:order_by_number, documents)
      action = Admin::Controllers::Docs::UpdateOrder.new(
        document_repo: document_repo, authenticator: authenticator
      )
      response = action.call(invalid_params)
      _(response[0]).must_equal 422
      _(action.documents).must_equal documents
      _(document_repo.verify).must_equal true
      _(authenticator.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:action) { Admin::Controllers::Docs::UpdateOrder.new(
      document_repo: nil, authenticator: authenticator
    ) }
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, Minitest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }

    it 'is redirected' do
      response = action.call(params)
      _(response[0]).must_equal 302
      _(authenticator.verify).must_equal true
    end
  end
end
