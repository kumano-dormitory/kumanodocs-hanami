require_relative '../../../spec_helper'

describe Web::Controllers::Gijiroku::Destroy do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]) }
    let(:gijiroku) { Gijiroku.new(id: rand(1..50)) }
    let(:params) { {id: gijiroku.id} }

    it 'is successful' do
      gijiroku_repo = MiniTest::Mock.new.expect(:find, gijiroku, [gijiroku.id])
                                        .expect(:delete, nil, [gijiroku.id])
      action = Web::Controllers::Gijiroku::Destroy.new(gijiroku_repo: gijiroku_repo, authenticator: authenticator)
      response = action.call(params)

      response[0].must_equal 302
      gijiroku_repo.verify.must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) { Web::Controllers::Gijiroku::Destroy.new(gijiroku_repo: nil, authenticator: authenticator) }

    it 'is redirected' do
      response = action.call({})
      response[0].must_equal 302
    end
  end
end
