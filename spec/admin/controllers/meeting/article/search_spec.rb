require 'spec_helper'

describe Admin::Controllers::Meeting::Article::Search do
  let(:action) { Admin::Controllers::Meeting::Article::Search.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
