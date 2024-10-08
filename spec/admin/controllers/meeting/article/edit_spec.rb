require 'spec_helper'
require_relative '../../../../../apps/admin/controllers/meeting/article/edit'

describe Admin::Controllers::Meeting::Article::Edit do
  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]) }
    let(:meetings) { [meeting] }
    let(:meeting) { Meeting.new(id: rand(1..50)) }
    let(:article) { Article.new(id: rand(1..100), meeting_id: meeting.id) }
    let(:recent_articles) { [Article.new(id: rand(1..100))] }
    let(:categories) { [Category.new(id: rand(1..4))] }
    let(:article_refs) { [ArticleReference.new(article_old_id: rand(1..100), article_new_id: article.id, same: true)] }
    let(:params) { {meeting_id: article.meeting_id, id: article.id} }

    it 'is successful' do
      action = Admin::Controllers::Meeting::Article::Edit.new(
        article_repo: Minitest::Mock.new.expect(:find_with_relations, article, [article.id])
                        .expect(:of_recent, recent_articles, [Hash]),
        meeting_repo: Minitest::Mock.new.expect(:desc_by_date, meetings),
        category_repo: Minitest::Mock.new.expect(:all, categories),
        article_reference_repo: Minitest::Mock.new.expect(:find_refs, article_refs, [article.id, Hash]),
        authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.meetings).must_equal meetings
      _(action.categories).must_equal categories
      _(action.article).must_equal article
      _(action.recent_articles).must_equal recent_articles
      _(action.article_refs_selected).must_equal({ same: [article_refs[0].article_old_id] })
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, Minitest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }

    it 'is redirected' do
      action = Admin::Controllers::Meeting::Article::Edit.new(
        article_repo: nil, meeting_repo: nil, category_repo: nil, article_reference_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
