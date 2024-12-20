require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/edit'

describe Web::Controllers::Article::Edit do
  describe 'when user is logged in' do
    let(:article) { Article.new(id: rand(1..100), meeting_id: meeting.id, meeting: meeting, author: author) }
    let(:author) { Author.new(id: rand(1..100), lock_key: lock_key)}
    let(:lock_key) { Faker::Internet.password }
    let(:meeting) { Meeting.new(id: rand(1..100), deadline: (Date.today + 30).to_time) }
    let(:categories) { [Category.new(id: rand(1..5))] }
    let(:article_ref) {
      ArticleReference.new(same: [true, false].sample,
        article_old_id: rand(1..100), article_new_id: article.id)
    }
    let(:article_refs_check) {
      if article_ref.same
        {same: [article_ref.article_old_id]}
      else
        {other: [article_ref.article_old_id]}
      end
    }
    let(:params) { {id: article.id} }

    # TODO: 追加議案の編集期間であるかを判断するサービスを実装してからテストを分けて書くこと
    it 'is successful' do
      article_repo = Minitest::Mock.new.expect(:find_with_relations, article, [article.id])
                                       .expect(:of_recent, [article], [Hash])
      meeting_repo = Minitest::Mock.new.expect(:in_time, [meeting])
      category_repo = Minitest::Mock.new.expect(:all, categories)
      action = Web::Controllers::Article::Edit.new(
        article_repo: article_repo,
        meeting_repo: meeting_repo,
        category_repo: category_repo,
        article_reference_repo: Minitest::Mock.new.expect(:find_refs, [article_ref], [article.id, Hash]),
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]),
      )
      params_with_lock_key = params.merge("HTTP_COOKIE"=>"article_lock_key=#{lock_key}")
      response = action.call(params_with_lock_key)

      _(response[0]).must_equal 200
      _(action.meetings).must_equal [meeting]
      _(action.categories).must_equal categories
      _(action.recent_articles).must_equal [article]
      _(action.article_refs_selected).must_equal article_refs_check
      _(article_repo.verify).must_equal true
      _(meeting_repo.verify).must_equal true
      _(category_repo.verify).must_equal true
    end

    it 'is redirected by auth failure' do
      article_repo = Minitest::Mock.new.expect(:find_with_relations, article, [article.id])
      action = Web::Controllers::Article::Edit.new(
        article_repo: article_repo, meeting_repo: nil, category_repo: nil, article_reference_repo: nil,
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]),
      )
      invalid_params = params.merge("HTTP_COOKIE"=>"article_lock_key=#{Faker::Internet.password}")
      response = action.call(invalid_params)
      _(response[0]).must_equal 302
      _(article_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) {  }

    it 'is redirected' do
      action = Web::Controllers::Article::Edit.new(
        article_repo: nil, meeting_repo: nil, category_repo: nil,
        article_reference_repo: nil, authenticator: authenticator
      )
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
