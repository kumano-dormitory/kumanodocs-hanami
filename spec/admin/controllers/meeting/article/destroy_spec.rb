require 'spec_helper'
require_relative '../../../../../apps/admin/controllers/meeting/article/destroy'

describe Admin::Controllers::Meeting::Article::Destroy do
  let(:action) { Admin::Controllers::Meeting::Article::Destroy.new }
  let(:article_repo) { ArticleRepository.new }
  let(:article) { create(:article) }
  let(:params) { {meeting_id: article.meeting_id, id: article.id} }
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]) }
    let(:article) { Article.new(id: rand(1..100), article_categories: [], categories: [], comments: [], tables: [], vote_results: []) }
    let(:params) { {id: article.id, meeting_id: rand(1..50), article: {confirm: true} } }
    let(:params_without_confirm) { {id: article.id, meeting_id: rand(1..50)} }

    it 'is successful delete article' do
      action = Admin::Controllers::Meeting::Article::Destroy.new(
        article_repo: MiniTest::Mock.new.expect(:find_with_relations, article, [article.id])
                        .expect(:delete, nil, [article.id]),
        admin_history_repo: MiniTest::Mock.new.expect(:add, nil, [:article_destroy, String]),
        authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 302
    end

    it 'is successful for confirmation' do
      action = Admin::Controllers::Meeting::Article::Destroy.new(
        article_repo: MiniTest::Mock.new.expect(:find_with_relations, article, [article.id]),
        admin_history_repo: nil, authenticator: authenticator,
      )
      response = action.call(params_without_confirm)
      response[0].must_equal 200
      action.article.must_equal article
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Meeting::Article::Destroy.new(
        article_repo: nil, admin_history_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 302
    end
  end
end
