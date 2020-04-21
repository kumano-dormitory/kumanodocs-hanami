require_relative '../../../spec_helper'

describe Admin::Controllers::Docs::Show do
  let(:action) { Admin::Controllers::Docs::Show.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
