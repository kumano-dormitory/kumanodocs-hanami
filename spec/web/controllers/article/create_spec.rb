require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/create'

describe Web::Controllers::Article::Create do
  let(:action) { Web::Controllers::Article::Create.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
