require_relative '../../../spec_helper'

describe Web::Controllers::Comment::Edit do
  describe 'when user is logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]) }
    let(:meeting) { Meeting.new(id: rand(1..50), articles: [article]) }
    let(:article) { Article.new(id: rand(1..100), categories: categories) }
    let(:categories) { [Category.new(id: rand(1..4), name: '採決', require_content: true)] }
    let(:comment) { Comment.new(id: rand(1..100), body: Faker::Lorem.paragraphs.join) }
    let(:vote_data) { {agree: rand(1..30), disagree: rand(1..30), onhold: rand(1..10)} }
    let(:block) { Block.new(id: rand(1..9)) }
    let(:params) { {meeting_id: meeting.id, block_id: block.id} }

    it 'is successful' do
      meeting_repo = Minitest::Mock.new.expect(:find_with_articles, meeting, [meeting.id])
      comment_repo = Minitest::Mock.new.expect(:find, comment, [article.id, params[:block_id]])
      vote_result_repo = Minitest::Mock.new.expect(:find, vote_data, [article.id, params[:block_id]])
      action = Web::Controllers::Comment::Edit.new(
        meeting_repo: meeting_repo, comment_repo: comment_repo, vote_result_repo: vote_result_repo, authenticator: authenticator
      )
      response = action.call(params)

      _(response[0]).must_equal 200
      _(action.meeting).must_equal meeting
      _(action.block_id).must_equal block.id
      _(action.comment_datas).must_equal([{article_id: article.id, comment: comment.body}])
      _(action.vote_result_datas).must_equal([{article_id: article.id, vote_result: vote_data}])
      _(meeting_repo.verify).must_equal true
      _(comment_repo.verify).must_equal true
      _(vote_result_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, false), [nil]) }

    it 'is redirected' do
      action = Web::Controllers::Comment::Edit.new(
        meeting_repo: nil, comment_repo: nil, vote_result_repo: nil, authenticator: authenticator
      )
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
