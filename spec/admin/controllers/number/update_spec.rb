require 'spec_helper'
require_relative '../../../../apps/admin/controllers/number/update'

describe Admin::Controllers::Number::Update do
  let(:action) { Admin::Controllers::Number::Update.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
