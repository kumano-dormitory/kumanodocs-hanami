# ====
# 議事録への返答の削除アクション
# ====
# 議事録への返答を削除する画面を表示する
# 初めに、返答を議案提起者として削除するか、議事録投稿者として削除するかを選択する画面を表示する
# その後、選択された役割に応じて返答の削除画面を表示する.(パスワードの入力を求める)
# パスワードが入力されて削除アクションが呼ばれた場合は、認証を行い下記の権限の確認を行ってから返答を削除する
# ※ 議事録投稿者は全ての返答を削除する権限をもち、議事録投稿者は自身が投稿した返答のみ削除する権限を持つ
# = 主な処理
# - 議案提起者として削除するか、議事録投稿者として削除するかが指定されているか確認する
# - パスワードが入力されている場合は、認証を行い削除権限のチェックをする
# - 議事録への返答をDBから削除する

module Web::Controllers::Comment
  module Message
    class Destroy
      include Web::Action
      expose :message, :messages, :comment, :view_type, :is_article_author

      params do
        required(:message).schema do
          required(:role) { filled? & str? & included_in?(['article-author','comment-author']) }
          optional(:password).filled(:str?)
        end
      end

      def initialize(message_repo: MessageRepository.new,
                     comment_repo: CommentRepository.new,
                     author_repo: AuthorRepository.new,
                     authenticator: JwtAuthenticator.new)
        @message_repo = message_repo
        @comment_repo = comment_repo
        @author_repo = author_repo
        @authenticator = authenticator
        @notifications = {}
      end

      def call(params)
        @message = @message_repo.find(params[:id])
        halt 404 unless @message
        @comment = @comment_repo.find_with_relations(@message.comment_id)
        @messages = @message_repo.by_article(@comment.article_id).group_by{|message| message.comment_id}
        if params.valid?
          author = @author_repo.find(@comment.article.author_id)
          if params[:message][:password]
            if params[:message][:role] == 'article-author'
              # 議案提起者として削除
              if author.authenticate(params[:message][:password])
                @message_repo.delete(@message.id)
                redirect_to routes.article_path(id: @comment.article_id)
              else
                @notifications = {error: {status: 'Authentication failed:', message: 'パスワードが間違っています. 正しいパスワードを入力してください'}}
              end
            else
              # 議事録の投稿者として削除
              if !@message.send_by_article_author
                if @comment.authenticate(params[:message][:password])
                  @message_repo.delete(@message.id)
                  redirect_to routes.article_path(id: @comment.article_id)
                else
                  @notifications = {error: {status: 'Authentication failed:', message: 'パスワードが間違っています. 正しいパスワードを入力してください'}}
                end
              else
                @notifications = {error: {status: 'Error:', message: '議事録の投稿者は、「議案提起者からの返答」を削除することはできません'}}
              end
            end
          end
          @view_type = :delete
          @is_article_author = params[:message][:role] == 'article-author'
        else
          @view_type = :select_role
        end
      end

      def notifications
        @notifications
      end
    end
  end
end
