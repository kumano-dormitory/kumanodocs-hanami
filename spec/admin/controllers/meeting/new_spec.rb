require_relative '../../../spec_helper'

describe Admin::Controllers::Meeting::New do
  let(:action) { Admin::Controllers::Meeting::New.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
