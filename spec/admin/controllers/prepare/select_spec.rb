require 'spec_helper'
require_relative '../../../../apps/admin/controllers/prepare/select'

describe Admin::Controllers::Prepare::Select do
  let(:action) { Admin::Controllers::Prepare::Select.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
