require_relative '../../../spec_helper'

describe Admin::Controllers::Meeting::Article::Comment::Update do
  let(:action) { Admin::Controllers::Meeting::Article::Comment::Update.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
