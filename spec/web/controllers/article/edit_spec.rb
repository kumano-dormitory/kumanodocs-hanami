require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/edit'

describe Web::Controllers::Article::Edit do
  let(:action) { Web::Controllers::Article::Edit.new }
  let(:params) { Hash[] }

  it 'is successful' do
    skip
    response = action.call(params)
    response[0].must_equal 200
  end
end
