require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/new'

describe Web::Controllers::Article::New do
  let(:action) { Web::Controllers::Article::New.new }
  let(:params) { Hash[] }

  it 'is successful' do
    skip
    response = action.call(params)
    response[0].must_equal 200
  end
end
