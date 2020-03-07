require_relative '../../../spec_helper'

describe Web::Controllers::Docs::Index do
  let(:action) { Web::Controllers::Docs::Index.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
