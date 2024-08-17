require 'spec_helper'

describe Admin::Controllers::History::Index do
  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]) }
    let(:histories) { [AdminHistory.new(id: rand(1..50))] }
    let(:params) { { page: [nil, rand(1..10)].sample } }

    it 'is successful' do
      action = Admin::Controllers::History::Index.new(
        admin_history_repo: Minitest::Mock.new.expect(:desc_by_created_at, histories, [Hash]),
        authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.histories).must_equal histories
      _(action.page).must_equal (params[:page].nil? ? 1 : params[:page])
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, Minitest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::History::Index.new(
        admin_history_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
