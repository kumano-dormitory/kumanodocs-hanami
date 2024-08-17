require_relative '../../../spec_helper'

describe Web::Controllers::Gijiroku::Index do
  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]) }
    let(:gijiroku) { Gijiroku.new(id: rand(1..50), body: Faker::Lorem.paragraphs.join) }
    let(:params) { {} }

    it 'is successful' do
      gijiroku_repo = Minitest::Mock.new.expect(:find_latest, gijiroku)
      action = Web::Controllers::Gijiroku::Index.new(gijiroku_repo: gijiroku_repo, authenticator: authenticator)
      response = action.call(params)

      _(response[0]).must_equal 200
      _(action.gijiroku).must_equal gijiroku
      _(gijiroku_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) { Web::Controllers::Gijiroku::Index.new(gijiroku_repo: nil, authenticator: authenticator) }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
