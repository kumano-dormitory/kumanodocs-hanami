require 'spec_helper'
require_relative '../../../../apps/admin/controllers/status/update'

describe Admin::Controllers::ArticleStatus::Update do
  let(:action) { Admin::Controllers::ArticleStatus::Update.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
