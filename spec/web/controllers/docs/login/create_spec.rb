require_relative '../../../../spec_helper'

describe Web::Controllers::Docs::Login::Create do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]) }
    let(:password) { Faker::Internet.password }
    let(:wrong_password) { Faker::Internet.password }
    let(:user) { User.new(id: rand(1..10), authority: 1, crypt_password: BCrypt::Password.create(password), name: Faker::Name.name) }
    let(:params) {{
      user: {name: user.name, password: password}
    }}
    let(:invalid_params) {{
      user: {name: user.name, password: wrong_password}
    }}

    it 'is successful login' do
      user_repo = MiniTest::Mock.new.expect(:find_by_name, user, [user.name])
      action = Web::Controllers::Docs::Login::Create.new(
        user_repo: user_repo, authenticator: authenticator
      )
      response = action.call(params)
      _(response[0]).must_equal 302
      _(user_repo.verify).must_equal true
    end

    it 'is rejected by wrong password' do
      user_repo = MiniTest::Mock.new.expect(:find_by_name, user, [user.name])
      action = Web::Controllers::Docs::Login::Create.new(
        user_repo: user_repo, authenticator: authenticator
      )
      response = action.call(invalid_params)
      _(response[0]).must_equal 403
      _(user_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) {
      Web::Controllers::Docs::Login::Create.new(
        user_repo: nil, authenticator: authenticator
      )
    }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
