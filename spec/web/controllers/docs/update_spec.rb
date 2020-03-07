require_relative '../../../spec_helper'

describe Web::Controllers::Docs::Update do
  let(:action) { Web::Controllers::Docs::Update.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
