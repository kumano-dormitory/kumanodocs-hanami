module Admin::Controllers::Meeting::Article::Lock
  class New
    include Admin::Action
    expose :locked

    def initialize(article_repo: ArticleRepository.new)
      @article_repo = article_repo
    end

    def call(params)
      article = @article_repo.find_with_relations(params[:article_id])
      @locked = article.author.locked?
    end
  end
end
