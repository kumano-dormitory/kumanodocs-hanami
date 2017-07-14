require 'spec_helper'
require_relative '../../../../apps/web/controllers/meeting/index'

describe Web::Controllers::Meeting::Index do
  let(:action) { Web::Controllers::Meeting::Index.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
