# ====
# 表の編集ページの表示アクション
# ====
# 表の編集ページを表示する
# 編集前に議案のパスワード認証を行っていない場合には、議案の編集の認証画面へリダイレクトする

module Web::Controllers::Table
  class Edit
    include Web::Action
    expose :table

    def initialize(table_repo: TableRepository.new,
                   authenticator: JwtAuthenticator.new)
      @table_repo = table_repo
      @authenticator = authenticator
    end

    def call(params)
      @table = @table_repo.find_with_relations(params[:id])
      if table.article.author.locked? && table.article.author.lock_key == cookies[:article_lock_key]
      else
        redirect_to routes.new_article_lock_for_table_path(
          article_id: table.article.id,
          table_id: table.id
        )
      end
    end
  end
end
