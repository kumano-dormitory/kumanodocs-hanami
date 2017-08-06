require 'spec_helper'
require_relative '../../../../apps/admin/controllers/meeting/index'

describe Admin::Controllers::Meeting::Index do
  let(:action) { Admin::Controllers::Meeting::Index.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
