require_relative '../../../spec_helper'

describe Web::Controllers::Login::Create do
  let(:gijiroku) { {body: Faker::Lorem.paragraphs.join} }
  let(:user) { User.new(id: rand(1..10), name: Faker::Lorem.word, authority: 0, crypt_password: crypt_password) }
  let(:password) { Faker::Internet.password }
  let(:crypt_password) { BCrypt::Password.create(password) }
  let(:params) { {login: {username: user.name, password: password}} }

  it 'is successful login' do
    user_repo = MiniTest::Mock.new.expect(:find_by_name, user, [user.name])
    action = Web::Controllers::Login::Create.new(user_repo: user_repo)
    response = action.call(params)

    response[0].must_equal 302
    user_repo.verify.must_equal true
  end

  let(:invalid_params) {{ login: {username: user.name, password: Faker::Internet.password} }}
  it 'is rejected by authentication failure' do
    user_repo = MiniTest::Mock.new.expect(:find_by_name, user, [user.name])
    action = Web::Controllers::Login::Create.new(user_repo: user_repo)
    response = action.call(invalid_params)

    response[0].must_equal 200
    action.standalone.must_equal false
    user_repo.verify.must_equal true
  end
end
