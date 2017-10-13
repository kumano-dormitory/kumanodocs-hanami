module Admin::Controllers::Meeting::Article::Lock
  class Create
    include Admin::Action

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

    def call(params)
      article = @article_repo.find_with_relations(params[:article_id])
      if article.author.authenticate(params[:author][:password])
        lock_key = @author_repo.lock(article.author_id, params[:author][:password])
        cookies[:article_lock_key] = lock_key
        redirect_to routes.edit_meeting_article_path(meeting_id: params[:meeting_id], id: params[:article_id])
      else
        self.status = 401
      end
    end
  end
end
