require 'spec_helper'
require_relative '../../../../../../apps/admin/controllers/meeting/article/lock/create'

describe Admin::Controllers::Meeting::Article::Lock::Create do
  let(:action) { Admin::Controllers::Meeting::Article::Lock::Create.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
