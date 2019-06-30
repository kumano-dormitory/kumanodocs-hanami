require 'spec_helper'

describe Web::Controllers::Article::Diff do
  let(:action) { Web::Controllers::Article::Diff.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
