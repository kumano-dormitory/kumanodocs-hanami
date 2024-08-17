require_relative '../../../spec_helper'

describe Web::Controllers::Gijiroku::Content do
  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]) }
    let(:gijiroku) { {body: Faker::Lorem.paragraphs.join} }
    let(:params) { {} }

    it 'is successful' do
      json_repo = Minitest::Mock.new.expect(:latest_gijiroku, gijiroku)
      action = Web::Controllers::Gijiroku::Content.new(json_repo: json_repo, authenticator: authenticator)
      response = action.call(params)

      _(response[0]).must_equal 200
      _(response[1]['Content-Type']).must_match 'text/plain'
      _(response[2].first).must_match gijiroku[:body]
      _(json_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) { Web::Controllers::Gijiroku::Content.new(authenticator: authenticator) }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
