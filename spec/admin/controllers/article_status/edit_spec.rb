require 'spec_helper'
require_relative '../../../../apps/admin/controllers/prepare/select'

describe Admin::Controllers::ArticleStatus::Edit do
  let(:action) { Admin::Controllers::ArticleStatus::Edit.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
