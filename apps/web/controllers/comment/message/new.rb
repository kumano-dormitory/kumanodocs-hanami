# ====
# 議事録への返答の投稿画面の表示アクション
# ====
# 議事録への返答を投稿する画面を表示する
# 議案の議事録の下にある返答ボタンから遷移してくる
# 初めに、返答を議案提起者として投稿するか、議事録投稿者として投稿するかを選択する画面を表示する
# その後、選択された役割に応じて返答の投稿画面を表示する
# = 主な処理
# - 議案提起者として返答するか、議事録投稿者として返答するかが指定されているか確認する
# - 返答が書きやすいように、議事録とその議事録への返答を全て投稿画面上部に表示する

module Web::Controllers::Comment
  module Message
    class New
      include Web::Action
      expose :comment, :messages, :view_type, :is_article_author

      params do
        required(:role) { filled? & str? & included_in?(['article-author', 'comment-author']) }
      end

      def initialize(comment_repo: CommentRepository.new,
                     message_repo: MessageRepository.new,
                     authenticator: JwtAuthenticator.new)
        @comment_repo = comment_repo
        @message_repo = message_repo
        @authenticator = authenticator
      end

      def call(params)
        @comment = @comment_repo.find_with_relations(params[:comment_id])
        @messages = @message_repo.by_article(@comment.article_id).group_by{|message| message.comment_id}
        if params.valid?
          if params[:role] == 'article-author'
            @is_article_author = true
          elsif params[:role] == 'comment-author'
            @is_article_author = false
          end
          @view_type = :form
        else
          @view_type = :select_role
        end
      end
    end
  end
end
