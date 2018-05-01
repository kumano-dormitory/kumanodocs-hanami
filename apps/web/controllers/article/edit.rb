module Web::Controllers::Article
  class Edit
    include Web::Action
    expose :article, :meetings, :categories

    def initialize(article_repo: ArticleRepository.new,
                   meeting_repo: MeetingRepository.new,
                   category_repo: CategoryRepository.new)
      @article_repo = article_repo
      @meeting_repo = meeting_repo
      @category_repo = category_repo
    end

    def call(params)
      @article = @article_repo.find_with_relations(params[:id])
      if @article.author.locked? && @article.author.lock_key == cookies[:article_lock_key]
        @meetings = @meeting_repo.in_time
        @categories = @category_repo.all
      else
        redirect_to routes.new_article_lock_path(article_id: article.id)
      end
    end
  end
end
