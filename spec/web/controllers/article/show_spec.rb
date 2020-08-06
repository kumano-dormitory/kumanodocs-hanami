require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/show'

describe Web::Controllers::Article::Show do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]) }
    let(:article) { Article.new(id: rand(1..100), meeting_id: meeting.id, meeting: meeting) }
    let(:meeting) { Meeting.new(id: rand(1..50), deadline: (Date.today + 30).to_time) }
    let(:blocks) { [Block.new(id: rand(1..9))] }
    let(:msg) { Message.new(id: rand(1..100), comment_id: rand(1..100)) }
    let(:messages_check) { {msg.comment_id => [msg]} }
    let(:article_refs) { [ArticleReference.new(article_old_id: rand(1..100), article_new_id: article.id)] }
    let(:params) { {id: article.id} }

    it 'is successful' do
      article_repo = MiniTest::Mock.new.expect(:find_with_relations, article, [article.id])
      action = Web::Controllers::Article::Show.new(
        article_repo: article_repo,
        block_repo: MiniTest::Mock.new.expect(:all, blocks),
        message_repo: MiniTest::Mock.new.expect(:by_article, [msg], [article.id]),
        article_reference_repo: MiniTest::Mock.new.expect(:find_refs, article_refs, [article.id]),
        meeting_repo: MiniTest::Mock.new.expect(:find_most_recent, meeting),
        authenticator: authenticator
      )
      response = action.call(params)

      _(response[0]).must_equal 200
      _(action.article).must_equal article
      _(action.blocks).must_equal blocks
      _(action.messages).must_equal messages_check
      _(action.editable).must_equal true
      _(article_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }

    it 'is redirected' do
      action = Web::Controllers::Article::Show.new(
        article_repo: nil, block_repo: nil, meeting_repo: nil, message_repo: nil,
        article_reference_repo: nil, authenticator: authenticator,
      )
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
