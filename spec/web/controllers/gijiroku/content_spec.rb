require_relative '../../../spec_helper'

describe Web::Controllers::Gijiroku::Content do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]) }
    let(:gijiroku) { {body: Faker::Lorem.paragraphs.join} }
    let(:params) { {} }

    it 'is successful' do
      json_repo = MiniTest::Mock.new.expect(:latest_gijiroku, gijiroku)
      action = Web::Controllers::Gijiroku::Content.new(json_repo: json_repo, authenticator: authenticator)
      response = action.call(params)

      response[0].must_equal 200
      response[1]['Content-Type'].must_match 'text/plain'
      response[2].first.must_match gijiroku[:body]
      json_repo.verify.must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) { Web::Controllers::Gijiroku::Content.new(authenticator: authenticator) }

    it 'is redirected' do
      response = action.call({})
      response[0].must_equal 302
    end
  end
end
