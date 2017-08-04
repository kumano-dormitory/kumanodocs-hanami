require 'spec_helper'
require_relative '../../../../../apps/web/controllers/article/lock/new'

describe Web::Controllers::Article::Lock::New do
  let(:action) { Web::Controllers::Article::Lock::New.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
