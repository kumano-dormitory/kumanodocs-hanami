require_relative '../../../spec_helper'

describe Admin::Controllers::Meeting::Create do
  describe 'when user is logged in' do
    def assert_invalid_params(invalid_params)
      action = Admin::Controllers::Meeting::Create.new(
        meeting_repo: nil, admin_history_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(invalid_params)
      response[0].must_equal 422
    end

    let(:valid_params) {{
      meeting: {
        date: "2019-10-10",
        deadline: "2019-10-08T21:00:00+00:00",
        ryoseitaikai: false,
      }
    }}
    let(:check_params) {{
      date: Date.new(2019, 10, 10),
      deadline: "2019-10-08T21:00:00+09:00",
      type: 0,
    }}
    let(:meeting) { Meeting.new(check_params.merge(id: rand(1..50))) }

    it 'is successful create meeting' do
      action = Admin::Controllers::Meeting::Create.new(
        meeting_repo: MiniTest::Mock.new.expect(:create, meeting, [check_params]),
        admin_history_repo: MiniTest::Mock.new.expect(:add, nil, [:meeting_create, String]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(valid_params)
      response[0].must_equal 302
    end

    it 'is validation error' do
      assert_invalid_params({meeting: valid_params[:meeting].merge(date: nil)})
      assert_invalid_params({meeting: valid_params[:meeting].merge(deadline: nil)})
      assert_invalid_params({meeting: valid_params[:meeting].merge(ryoseitaikai: nil)})
      assert_invalid_params({meeting: valid_params[:meeting].merge(deadline: "2019-10-20T21:00+00:00")})
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }

    it 'is redirected' do
      action = Admin::Controllers::Meeting::Create.new(
        meeting_repo: nil, admin_history_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 302
    end
  end
end
