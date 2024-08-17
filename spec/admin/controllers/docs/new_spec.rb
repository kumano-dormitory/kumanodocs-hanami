require_relative '../../../spec_helper'

describe Admin::Controllers::Docs::New do
  let(:action) { Admin::Controllers::Docs::New.new(
    user_repo: user_repo, authenticator: authenticator
    )
  }
  let(:user) { User.new(id: rand(1..10)) }
  let(:params) { Hash[] }

  describe 'when user is logged in' do
    let(:user_repo) { Minitest::Mock.new.expect(:by_authority, [user], [1]) }
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]) }
    it 'is successful' do
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.users).must_equal [user]
      _(user_repo.verify).must_equal true
      _(authenticator.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:user_repo) { nil }
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, Minitest::Mock.new.expect(:user, nil), [nil]) }
    it 'is redirected' do
      response = action.call(params)
      _(response[0]).must_equal 302
      _(authenticator.verify).must_equal true
    end
  end
end
