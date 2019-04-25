module Web::Controllers::Article
  class Destroy
    include Web::Action
    expose :article

    def initialize(article_repo: ArticleRepository.new)
      @article_repo = article_repo
      @notifications = {}
    end

    def call(params)
      @article = @article_repo.find_with_relations(params[:id])
      # パスワード入力画面から遷移してきてパラメータにパスワードがある場合
      if !params[:article].nil?
        if @article.author.authenticate(params[:article][:password])
          @article_repo.delete(params[:id])
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
