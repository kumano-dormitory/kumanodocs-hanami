require 'spec_helper'
require_relative '../../../../../apps/admin/controllers/meeting/article/edit'

describe Admin::Controllers::Meeting::Article::Edit do
  let(:action) { Admin::Controllers::Meeting::Article::Edit.new }
  let(:author_repo) { AuthorRepository.new }
  let(:article) { create(:article) }
  let(:params) { {meeting_id: article.meeting_id, id: article.id} }

  it 'is successful' do
    lock_key = author_repo.lock(article.author_id, '')
    params.merge!("HTTP_COOKIE"=>"article_lock_key=#{lock_key}")
    response = action.call(params)
    response[0].must_equal 200
  end

  it 'is redirected' do
    response = action.call(params)
    response[0].must_equal 302
  end
end
