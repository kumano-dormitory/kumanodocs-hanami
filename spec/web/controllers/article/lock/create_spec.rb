require 'spec_helper'
require_relative '../../../../../apps/web/controllers/article/lock/create'

describe Web::Controllers::Article::Lock::Create do
  let(:action) { Web::Controllers::Article::Lock::Create.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
