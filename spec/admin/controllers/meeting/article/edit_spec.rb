require 'spec_helper'
require_relative '../../../../../apps/admin/controllers/meeting/article/edit'

describe Admin::Controllers::Meeting::Article::Edit do
  let(:meeting) { Meeting.new(id: rand(1..5)) }
  let(:article) { Article.new(id: rand(1..5), meeting_id: meeting.id) }
  let(:params) { {meeting_id: article.meeting_id, id: article.id} }

  it 'is successful' do
    article_repo = MiniTest::Mock.new.expect(:find_with_relations, article, [article.id])
    meeting_repo = MiniTest::Mock.new.expect(:in_time, [meeting])
    category_repo = MiniTest::Mock.new.expect(:all, [Category.new(id: rand(1..5))])

    action = Admin::Controllers::Meeting::Article::Edit.new(article_repo: article_repo,
                                                            meeting_repo: meeting_repo,
                                                            category_repo: category_repo)
    response = action.call(params)

    article_repo.verify.must_equal true

    response[0].must_equal 200
  end
end
