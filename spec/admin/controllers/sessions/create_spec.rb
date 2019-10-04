require 'spec_helper'

describe Admin::Controllers::Sessions::Create do
  let(:password) { Faker::Internet.password }
  let(:crypt_password) { BCrypt::Password.create(password) }
  let(:user) { User.new(id: rand(1..50), name: 'admin', authority: 1, crypt_password: crypt_password) }
  let(:valid_params) {{
    session: {
      adminname: user.name,
      password: password,
    }
  }}

  it 'is successful create session' do
    admin_history_repo = MiniTest::Mock.new.expect(:add, nil, [:sessions_create, String])
    action = Admin::Controllers::Sessions::Create.new(
      user_repo: MiniTest::Mock.new.expect(:find_by_name, user, [user.name]),
      admin_history_repo: admin_history_repo,
    )
    response = action.call(valid_params)
    response[0].must_equal 302
    admin_history_repo.verify.must_equal true
  end

  let(:wrong_pass_params) {{
    session: { adminname: user.name, password: 'abc'}
  }}

  it 'is wrong password' do
    user_repo = MiniTest::Mock.new.expect(:find_by_name, user, [user.name])
    action = Admin::Controllers::Sessions::Create.new(
      user_repo: user_repo, admin_history_repo: nil,
    )
    response = action.call(wrong_pass_params)
    response[0].must_equal 200
    action.name.must_equal user.name
    user_repo.verify.must_equal true
  end

  it 'is validation error' do
    action = Admin::Controllers::Sessions::Create.new(user_repo: nil, admin_history_repo: nil)
    response = action.call({session: {}})

    response[0].must_equal 200
    assert_nil action.name
  end
end
