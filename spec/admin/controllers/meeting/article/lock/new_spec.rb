require 'spec_helper'
require_relative '../../../../../../apps/admin/controllers/meeting/article/lock/new'

describe Admin::Controllers::Meeting::Article::Lock::New do
  let(:action) { Admin::Controllers::Meeting::Article::Lock::New.new }
  let(:author_repo) { AuthorRepository.new }
  let(:article) { create(:article) }
  let(:params) { {meeting_id: article.meeting_id, article_id: article.id} }

  it 'is successful (locked)' do
    author_repo.lock(article.author_id, '')
    response = action.call(params)
    response[0].must_equal 200

    action.locked.must_equal true
  end

  it 'is successful (unlocked)' do
    author_repo.release_lock(article.author_id)
    response = action.call(params)
    response[0].must_equal 200

    action.locked.must_equal false
  end
end
