module Web::Controllers::Article::Lock
  class New
    include Web::Action
    expose :locked

    def initialize(article_repo: ArticleRepository.new)
      @article_repo = article_repo
    end

    def call(params)
      article = @article_repo.find_with_author(params[:article_id])
      @locked = article.author.locked?
    end
  end
end
