require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/destroy'

describe Web::Controllers::Article::Destroy do
  let(:action) { Web::Controllers::Article::Destroy.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
