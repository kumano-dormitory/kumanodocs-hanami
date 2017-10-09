require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/show'

describe Web::Controllers::Article::Show do
  let(:action) { Web::Controllers::Article::Show.new }
  let(:params) { Hash[] }

  it 'is successful' do
    skip
    response = action.call(params)
    response[0].must_equal 200
  end
end
