require 'spec_helper'
require_relative '../../../../apps/admin/controllers/article_number/edit'

describe Admin::Controllers::ArticleNumber::Edit do
  let(:action) { Admin::Controllers::ArticleNumber::Edit.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end