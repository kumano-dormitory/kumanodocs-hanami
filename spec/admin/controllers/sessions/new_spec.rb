require 'spec_helper'

describe Admin::Controllers::Sessions::New do
  let(:action) { Admin::Controllers::Sessions::New.new }
  let(:params) { {} }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
