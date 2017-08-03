require 'spec_helper'
require_relative '../../../../apps/admin/controllers/meeting/show'

describe Admin::Controllers::Meeting::Show do
  let(:action) { Admin::Controllers::Meeting::Show.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
