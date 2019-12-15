# ====
# 議案の編集前ログインアクション
# ====
# 議案の編集前のログインを行う
# = 主な処理
# - 議案のidとパスワードを受け取り、認証を行う
# - 認証が成功した場合には、編集ロックを取る
# - 認証が失敗した場合には、再度ログイン画面を表示

module Web::Controllers::Article::Lock
  class Create
    include Web::Action
    expose :for_table, :table_id

    params do
      required(:article_id).filled(:int?)
      optional(:table_id).filled(:int?)
      required(:author).schema do
        required(:password).filled(:str?)
      end
    end

    def initialize(article_repo: ArticleRepository.new,
                   author_repo: AuthorRepository.new,
                   authenticator: JwtAuthenticator.new)
      @article_repo = article_repo
      @author_repo = author_repo
      @authenticator = authenticator
      @notifications = {}
    end

    # article_idとpasswordを受け取り、passwordが正しければarticle_lock_keyを設定する
    def call(params)
      if params.valid?
        article = @article_repo.find_with_relations(params[:article_id])
        if article.author.authenticate(params[:author][:password])
          lock_key = @author_repo.lock(article.author_id, params[:author][:password])
          cookies[:article_lock_key] = lock_key
          if params[:table_id].nil?
            redirect_to routes.edit_article_path(id: article.id)
          else
            redirect_to routes.edit_table_path(id: params[:table_id])
          end
        end
      end
      @for_table = !params[:table_id].nil?
      @table_id = params[:table_id]
      @notifications = {error: {status: "Authentication Failed:", message: "パスワードが不正です. 正しいパスワードを入力してください"}}
      self.status = 401
    end

    def notifications
      @notifications
    end
  end
end
