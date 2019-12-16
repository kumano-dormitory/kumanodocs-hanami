# ====
# 議案の編集前ログイン画面表示アクション
# ====
# 議案の編集前のログイン画面を表示する
# = 主な処理
# - ログイン画面を表示する
# - 議案のロックが既に取られている場合には、他の人が編集中の可能性があるという旨を表示する

module Web::Controllers::Article::Lock
  class New
    include Web::Action
    expose :locked, :title, :for_table, :table_id

    def initialize(article_repo: ArticleRepository.new,
                   authenticator: JwtAuthenticator.new)
      @article_repo = article_repo
      @authenticator = authenticator
    end

    def call(params)
      article = @article_repo.find_with_relations(params[:article_id])
      @locked = article.author.locked?
      @title = article.title
      @for_table = !params[:table_id].nil?
      @table_id = params[:table_id]
    end
  end
end
