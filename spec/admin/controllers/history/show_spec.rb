require 'spec_helper'

describe Admin::Controllers::History::Show do
  describe 'when user is logged in' do
    let(:history) { AdminHistory.new(id: rand(1..50)) }
    let(:params) { { id: history.id } }

    it 'is successful' do
      action = Admin::Controllers::History::Show.new(
        admin_history_repo: Minitest::Mock.new.expect(:find, history, [history.id]),
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.history).must_equal history
    end

    it 'is not found' do
      action = Admin::Controllers::History::Show.new(
        admin_history_repo: Minitest::Mock.new.expect(:find, nil, [history.id]),
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(params)
      _(response[0]).must_equal 404
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, Minitest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::History::Show.new(
        admin_history_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
