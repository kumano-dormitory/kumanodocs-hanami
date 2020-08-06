require 'spec_helper'

describe Admin::Controllers::Message::New do
  describe 'when user is logged in' do
    let(:comment) { Comment.new(id: rand(1..100), article_id: rand(1..100)) }
    let(:msg) { Message.new(id: rand(1..100), comment_id: comment.id) }
    let(:params) { { id: msg.id, comment_id: comment.id } }

    it 'is successful' do
      action = Admin::Controllers::Message::New.new(
        comment_repo: MiniTest::Mock.new.expect(:find_with_relations, comment, [comment.id]),
        message_repo: MiniTest::Mock.new.expect(:by_article, [msg], [comment.article_id]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.comment).must_equal comment
      _(action.messages).must_equal({comment.id => [msg]})
    end

    it 'is invalid params error' do
      action = Admin::Controllers::Message::New.new(
        comment_repo: nil, message_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(params.merge({comment_id: nil}))
      _(response[0]).must_equal 404
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Message::New.new(
        comment_repo: nil, message_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
