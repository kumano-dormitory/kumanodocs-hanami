# ====
# 表の新規投稿ページの表示アクション
# ====
# 表の新規投稿ページを表示する

module Web::Controllers::Table
  class New
    include Web::Action
    expose :articles, :article_id

    def initialize(article_repo: ArticleRepository.new,
                   authenticator: JwtAuthenticator.new)
      @article_repo = article_repo
      @authenticator = authenticator
    end

    def call(params)
      if params[:article_id]
        @article_id = params[:article_id].to_i
      end
      if after_deadline?
        # 締め切り後なので追加議案にのみ表が追加できる
        @articles = @article_repo.not_checked_for_next_meeting
      else
        # 締め切り前なので、締切を過ぎていない議案全てに表が投稿できる
        @articles = @article_repo.before_deadline
      end
    end
  end
end
