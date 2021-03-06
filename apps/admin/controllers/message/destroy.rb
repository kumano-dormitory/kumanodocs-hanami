module Admin::Controllers::Message
  class Destroy
    include Admin::Action
    expose :comment, :messages, :message

    params do
      required(:article_id).filled(:int?)
      required(:comment_id).filled(:int?)
      required(:id).filled(:int?)
      required(:message).schema do
        required(:check).filled(:bool?)
      end
    end

    def initialize(article_repo: ArticleRepository.new,
                   comment_repo: CommentRepository.new,
                   message_repo: MessageRepository.new,
                   admin_history_repo: AdminHistoryRepository.new,
                   authenticator: AdminAuthenticator.new)
      @article_repo = article_repo
      @comment_repo = comment_repo
      @message_repo = message_repo
      @admin_history_repo = admin_history_repo
      @authenticator = authenticator
    end

    def call(params)
      @comment = @comment_repo.find_with_relations(params[:comment_id])
      @messages = @message_repo.by_article(@comment.article_id).group_by{|message| message.comment_id}
      @message = @message_repo.find(params[:id])
      if params.valid? && params[:message][:check]
        article = @article_repo.find(params[:article_id])
        halt 400 unless @comment.article_id == params[:article_id] && @message.comment_id == params[:comment_id]

        @message_repo.delete(@message.id)
        @admin_history_repo.add(:message_destroy, gen_history_json(article, @comment, @message))
        flash[:notifications] = {success: {status: 'Success:', message: '正常に議事録に対する返答が削除されました'}}
        redirect_to routes.meeting_article_path(meeting_id: article.meeting_id, id: article.id)
      else
        @notifications = {info: {status: '', message: '削除の確認のチェックボックにチェックを入れてから削除ボタンを押してください'}}
      end
    end

    def gen_history_json(article, comment, message)
      JSON.pretty_generate({
        action: "message_destroy",
        payload: {
          article: article.to_h.slice(:id, :title, :meeting_id),
          comment: comment.to_h.slice(:id).merge({block: {name: comment.block.name}}),
          message: @message.to_h
        }
      })
    end

    def notifications
      @notifications
    end
  end
end
