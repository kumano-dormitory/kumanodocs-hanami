require 'spec_helper'
require_relative '../../../../apps/admin/controllers/prepare/arrange'

describe Admin::Controllers::Prepare::Arrange do
  let(:action) { Admin::Controllers::Prepare::Arrange.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
