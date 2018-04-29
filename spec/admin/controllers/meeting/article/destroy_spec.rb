require 'spec_helper'
require_relative '../../../../../apps/admin/controllers/meeting/article/destroy'

describe Admin::Controllers::Meeting::Article::Destroy do
  let(:action) { Admin::Controllers::Meeting::Article::Destroy.new }
  let(:article_repo) { ArticleRepository.new }
  let(:article) { create(:article) }
  let(:params) { {meeting_id: article.meeting_id, id: article.id} }

  it 'is successful' do
    article = create(:article)
    pre_article_count = article_repo.all.count

    response = action.call({meeting_id: article.meeting_id, id: article.id})
    response[0].must_equal 302

    article_repo.all.count.must_equal pre_article_count - 1
  end
end
