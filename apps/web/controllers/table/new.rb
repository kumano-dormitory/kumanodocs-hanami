module Web::Controllers::Table
  class New
    include Web::Action
    expose :articles

    def initialize(article_repo: ArticleRepository.new)
      @article_repo = article_repo
    end

    def call(params)
      @articles = @article_repo.before_deadline
    end
  end
end
