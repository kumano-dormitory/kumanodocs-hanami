require 'spec_helper'

describe Admin::Controllers::Message::Edit do
  describe 'when user is logged in' do
    let(:comment) { Comment.new(id: rand(1..100), article_id: rand(1..100)) }
    let(:msg) { Message.new(id: rand(1..100), comment_id: comment.id) }
    let(:params) { { id: msg.id, comment_id: comment.id } }

    it 'is successful' do
      action = Admin::Controllers::Message::Edit.new(
        comment_repo: Minitest::Mock.new.expect(:find_with_relations, comment, [comment.id]),
        message_repo: Minitest::Mock.new.expect(:find, msg, [msg.id])
                                        .expect(:by_article, [msg], [comment.article_id]),
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.comment).must_equal comment
      _(action.message).must_equal msg
      _(action.messages).must_equal({comment.id => [msg]})
    end

    it 'is invalid params error' do
      action = Admin::Controllers::Message::Edit.new(
        comment_repo: nil, message_repo: nil,
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(params.merge([{id: nil},{comment_id: nil}].sample))
      _(response[0]).must_equal 400
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, Minitest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Message::Edit.new(
        comment_repo: nil, message_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
