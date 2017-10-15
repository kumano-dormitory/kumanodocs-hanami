require 'spec_helper'
require_relative '../../../../../apps/admin/controllers/meeting/article/index'

describe Admin::Controllers::Meeting::Article::Index do
  let(:action) { Admin::Controllers::Meeting::Article::Index.new(article_repo: article_repo) }
  let(:article_repo) { ArticleRepository.new }
  let(:meeting) { create(:meeting) }
  let(:articles) { create_list(:article, 5, meeting_id: meeting.id) }
  let(:params) { {meeting_id: meeting.id} }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200

    action.articles.each_with_index do |article, index|
      article.title.must_equal articles[index].title
      article.body.must_equal articles[index].body
      article.meeting_id.must_equal meeting.id
    end
  end
end
