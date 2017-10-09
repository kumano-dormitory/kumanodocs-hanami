require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/update'

describe Web::Controllers::Article::Update do
  let(:action) { Web::Controllers::Article::Update.new }
  let(:params) { Hash[] }

  it 'is successful' do
    skip
    response = action.call(params)
    response[0].must_equal 200
  end
end
