# ====
# 議案の削除アクション
# ====
# 確認パラメータがない場合（パラメータなしでアクセスした場合）は、議案の削除を確認するページを表示
# 確認パラメータが存在し、議案のパスワードが正しい場合に議案をDBから削除
# = 主な処理
# - 入力された議案のパスワードの検証
# - 議案の削除

module Web::Controllers::Article
  class Destroy
    include Web::Action
    expose :article

    # Dependency injection
    # authenticatorは認証モジュールで必須(../authentication.rb)
    def initialize(article_repo: ArticleRepository.new,
                   authenticator: JwtAuthenticator.new)
      @article_repo = article_repo
      @authenticator = authenticator
      @notifications = {}
    end

    def call(params)
      @article = @article_repo.find_with_relations(params[:id])
      # パスワード入力画面から遷移してきてパラメータにパスワードがある場合
      if !params[:article].nil?
        if @article.author.authenticate(params[:article][:password])
          @article_repo.delete(params[:id])
          flash[:notifications] = {success: {status: "Success", message: "正常に議案が削除されました. (議案題名：#{@article.title})"}}
          redirect_to routes.articles_path
        else
          @notifications = {error: {status: "Authentication Failed:", message: "パスワードが間違っています. 正しいパスワードを入力してください"}}
          self.status = 401
        end
      end
    end

    def notifications
      @notifications
    end
  end
end
