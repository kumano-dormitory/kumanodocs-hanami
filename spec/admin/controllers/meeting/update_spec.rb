require_relative '../../../spec_helper'

describe Admin::Controllers::Meeting::Update do
  describe 'when user is logged in' do
    def assert_invalid_params(invalid_params)
      action = Admin::Controllers::Meeting::Update.new(
        meeting_repo: Minitest::Mock.new.expect(:find, old_meeting, [meeting.id]), admin_history_repo: nil,
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(invalid_params)
      _(response[0]).must_equal 422
    end

    let(:old_meeting) { Meeting.new(id: rand(1..50), date: Date.new(2019,10,10), deadline: "2019-10-08T21:00:00+09:00", type: 0) }
    let(:date) { Date.new(rand(2017...2020), rand(1...12), [5,20].sample) }
    let(:deadline) { (date - 2).to_time }
    let(:type) { [0, 1].sample }
    let(:meeting) { Meeting.new(id: old_meeting.id, date: date, deadline: deadline, type: type) }
    let(:valid_params) {{
      id: old_meeting.id,
      meeting: {
        date: meeting.date.to_s,
        deadline: meeting.deadline.strftime("%FT%T%:z"),
        ryoseitaikai: (meeting.type == 1),
      }
    }}
    let(:check_params) {{
      date: meeting.date,
      deadline: meeting.deadline.strftime("%FT%T%:z").gsub(/\+00:00/,"+09:00"),
      type: meeting.type,
    }}

    it 'is successful create meeting' do
      action = Admin::Controllers::Meeting::Update.new(
        meeting_repo: Minitest::Mock.new.expect(:find, old_meeting, [meeting.id])
                        .expect(:update, meeting, [meeting.id, check_params]),
        admin_history_repo: Minitest::Mock.new.expect(:add, nil, [:meeting_update, String]),
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(valid_params)
      _(response[0]).must_equal 302
    end

    it 'is validation error' do
      assert_invalid_params({id: meeting.id, meeting: valid_params[:meeting].merge(date: nil)})
      assert_invalid_params({id: meeting.id, meeting: valid_params[:meeting].merge(deadline: nil)})
      assert_invalid_params({id: meeting.id, meeting: valid_params[:meeting].merge(ryoseitaikai: nil)})
      assert_invalid_params({id: meeting.id, meeting: valid_params[:meeting].merge(deadline: (date + 10).to_time.strftime("%FT%T%:z"))})
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, Minitest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }

    it 'is redirected' do
      action = Admin::Controllers::Meeting::Update.new(
        meeting_repo: nil, admin_history_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
