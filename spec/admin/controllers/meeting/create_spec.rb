require_relative '../../../spec_helper'

describe Admin::Controllers::Meeting::Create do
  let(:action) { Admin::Controllers::Meeting::Create.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
