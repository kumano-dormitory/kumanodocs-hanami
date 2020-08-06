require_relative '../../../spec_helper'

describe Admin::Controllers::Docs::Update do
  let(:action) { Admin::Controllers::Docs::Update.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    _(response[0]).must_equal 200
  end
end
