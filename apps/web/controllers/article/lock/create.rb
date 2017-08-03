module Web::Controllers::Article::Lock
  class Create
    include Web::Action

    params do
      required(:author).schema do
        required(:password).filled(:str?)
      end
    end

    def initialize(article_repo: ArticleRepository.new,
                   author_repo: AuthorRepository.new)
      @article_repo = article_repo
      @author_repo = author_repo
    end

    # article_idとpasswordを受け取り、passwordが正しければarticle_lock_keyを設定する
    def call(params)
      article = @article_repo.with_author(params[:article_id])
      if article.author.authenticate(params[:author][:password])
        lock_key = @author_repo.lock(article.author_id, params[:password])
        cookies[:article_lock_key] = lock_key
        # redirect_to routes.edit_article_path(id: article.id)
      else
        self.status = 401
      end
    end
  end
end
