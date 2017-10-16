require 'spec_helper'
require_relative '../../../../../apps/admin/controllers/meeting/article/edit'

describe Admin::Controllers::Meeting::Article::Edit do
  let(:action) { Admin::Controllers::Meeting::Article::Edit.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
