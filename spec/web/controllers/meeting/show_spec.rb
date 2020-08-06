require_relative '../../../spec_helper'

describe Web::Controllers::Meeting::Show do
  describe 'when user is logged in' do
    let(:meeting) { Meeting.new(id: rand(1..5), deadline: (Date.today + 30).to_time, articles: articles) }
    let(:articles) { [article] }
    let(:article) { Article.new(id: rand(1..5)) }
    let(:article_with_relations) { Article.new(id: article.id, meeting: meeting) }
    let(:msg) { Message.new(id: rand(1..100), comment_id: rand(1..100)) }
    let(:blocks) { [Block.new(id: rand(1..9))] }
    let(:article_refs) { [ArticleReference.new(id: rand(1..100))] }
    let(:params) { {id: meeting.id, page: 1} }

    it 'is successful' do
      article_repo = MiniTest::Mock.new.expect(:find_with_relations, article_with_relations, [article.id])
      action = Web::Controllers::Meeting::Show.new(
        meeting_repo: MiniTest::Mock.new.expect(:find_with_articles, meeting, [meeting.id]),
        article_repo: article_repo, comment_repo: nil,
        block_repo: MiniTest::Mock.new.expect(:all, blocks),
        message_repo: MiniTest::Mock.new.expect(:by_article, [msg], [article.id]),
        article_reference_repo: MiniTest::Mock.new.expect(:find_refs, article_refs, [article.id]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.meeting).must_equal meeting
      _(action.article).must_equal article_with_relations
      _(action.messages).must_equal({msg.comment_id => [msg]})
      _(action.article_refs).must_equal article_refs
      _(action.blocks).must_equal blocks
      _(article_repo.verify).must_equal true
    end

    let(:past_meeting) { Meeting.new(id: rand(1..100)) }
    let(:comment) { {id: rand(1..100), article_id: article.id} }
    let(:msg_hash) { {id: rand(1..100), comment_id: comment[:id]} }
    it 'is successful display comments of past meeting' do
      meeting_repo = MiniTest::Mock.new.expect(:find_with_articles, meeting, [meeting.id])
                                       .expect(:find_past_meeting, past_meeting, [meeting.id])
      action = Web::Controllers::Meeting::Show.new(
        meeting_repo: meeting_repo,
        block_repo: MiniTest::Mock.new.expect(:all, blocks),
        comment_repo: MiniTest::Mock.new.expect(:by_meeting, [comment], [past_meeting.id]),
        message_repo: MiniTest::Mock.new.expect(:by_meeting, [msg_hash], [past_meeting.id]),
        article_repo: nil, article_reference_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      response = action.call(params.merge(page: 0))
      _(response[0]).must_equal 200
      _(action.meeting).must_equal meeting
      _(action.past_meeting).must_equal past_meeting
      _(action.past_comments).must_equal({comment[:article_id] => [comment]})
      _(action.past_messages).must_equal({comment[:id] => [msg_hash]})
      _(action.blocks).must_equal blocks
      _(meeting_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) { Web::Controllers::Meeting::Index.new(authenticator: authenticator) }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
