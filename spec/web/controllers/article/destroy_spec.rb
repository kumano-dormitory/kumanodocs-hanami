require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/destroy'

describe Web::Controllers::Article::Destroy do
  let(:action) { Web::Controllers::Article::Destroy.new }
  let(:article) { create(:article) }
  let(:params) { {id: article.id} }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 302
  end
end
