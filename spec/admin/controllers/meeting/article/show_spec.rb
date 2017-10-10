require 'spec_helper'
require_relative '../../../../../apps/admin/controllers/meeting/article/show'

describe Admin::Controllers::Meeting::Article::Show do
  let(:action) { Admin::Controllers::Meeting::Article::Show.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
