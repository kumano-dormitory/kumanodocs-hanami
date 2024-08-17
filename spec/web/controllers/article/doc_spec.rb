require_relative '../../../spec_helper'

describe Web::Controllers::Article::Doc do
  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]) }
    let(:action) { Web::Controllers::Article::Doc.new(authenticator: authenticator) }
    let(:params) { {type: [nil, 0, 1, 2, 3, 4].sample} }

    it 'is successful' do
      response = action.call(params)

      _(response[0]).must_equal 200
      if params[:type].nil? || params[:type] > 3
        _(action.type).must_equal 0
      else
        _(action.type).must_equal params[:type]
      end
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) { Web::Controllers::Article::Doc.new(authenticator: authenticator) }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
