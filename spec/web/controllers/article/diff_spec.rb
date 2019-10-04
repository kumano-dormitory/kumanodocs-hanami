require 'spec_helper'

describe Web::Controllers::Article::Diff do
  describe 'when user is logged in' do
    let(:old_article) { Article.new(id: rand(1..100)) }
    let(:new_article) { Article.new(id: rand(1..100)) }
    let(:valid_params) {{
      diff: {
        old_article: old_article.id,
        new_article: new_article.id,
      },
    }}

    it 'is successful diff page' do
      article_repo = MiniTest::Mock.new.expect(
        :find_with_relations, old_article, [old_article.id]
      ).expect(
        :find_with_relations, new_article, [new_article.id]
      )
      action = Web::Controllers::Article::Diff.new(
        article_repo: article_repo,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      response = action.call(valid_params)

      response[0].must_equal 200
      action.article_old.must_equal old_article
      action.article_new.must_equal new_article
      article_repo.verify.must_equal true
    end

    let(:article) { Article.new(id: rand(1..100)) }
    let(:meeting) { Meeting.new(id: rand(1..50), articles: [article]) }
    it 'is successful select articles page' do
      article_repo = MiniTest::Mock.new.expect(:group_by_meeting, [meeting], [Integer, Hash])
      action = Web::Controllers::Article::Diff.new(
        article_repo: article_repo,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      empty_params = {}
      response = action.call(empty_params)

      response[0].must_equal 200
      action.recent_meetings_with_articles.must_equal [meeting]
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    it 'is redirected' do
      action = Web::Controllers::Article::Diff.new(
        article_repo: nil, authenticator: authenticator
      )
      response = action.call({})
      response[0].must_equal 302
    end
  end
end
