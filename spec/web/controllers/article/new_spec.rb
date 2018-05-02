require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/new'

describe Web::Controllers::Article::New do
  let(:meetings) { [Meeting.new(id: rand(1..5))] }
  let(:categories) { [Category.new(id: rand(1..5))] }
  let(:params) { Hash[] }

  it 'is successful' do
    action = Web::Controllers::Article::New.new(
      meeting_repository: MiniTest::Mock.new.expect(:in_time, meetings),
      category_repository: MiniTest::Mock.new.expect(:all, categories)
    )
    response = action.call(params)

    action.meetings.must_equal meetings
    action.categories.must_equal categories
    response[0].must_equal 200
  end
end
