require 'spec_helper'
require_relative '../../../../../apps/admin/controllers/meeting/article/new'

describe Admin::Controllers::Meeting::Article::New do
  let(:action) { Admin::Controllers::Meeting::Article::New.new }
  let(:meeting_repo) { MeetingRepository.new }
  let(:category_repo) { CategoryRepository.new }
  let(:meetings_in_time) { meeting_repo.in_time }
  let(:categories) { category_repo.all }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200

    action.meetings.must_equal meetings_in_time
    action.categories.must_equal categories
  end
end
