require 'spec_helper'

describe Admin::Controllers::Meeting::Article::New do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]) }
    let(:meeting) { Meeting.new(id: rand(1..50)) }
    let(:articles) { [Article.new(id: rand(1..100))] }
    let(:categories) { [Category.new(id: rand(1..4))] }
    let(:params) { { meeting_id: meeting.id } }

    it 'is successful' do
      action = Admin::Controllers::Meeting::Article::New.new(
        meeting_repo: MiniTest::Mock.new.expect(:find, meeting, [meeting.id]),
        article_repo: MiniTest::Mock.new.expect(:of_recent, articles, [Hash]),
        category_repo: MiniTest::Mock.new.expect(:all, categories),
        authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 200
    end
  end

  describe 'when use is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Meeting::Article::New.new(
        meeting_repo: nil, article_repo: nil, category_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 302
    end
  end
end
