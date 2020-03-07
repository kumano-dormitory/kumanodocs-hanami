require_relative '../../../spec_helper'

describe Web::Controllers::Docs::Edit do
  let(:action) { Web::Controllers::Docs::Edit.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
