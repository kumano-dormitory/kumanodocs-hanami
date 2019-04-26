module Web::Controllers::Table
  class New
    include Web::Action
    expose :articles, :article_id

    def initialize(article_repo: ArticleRepository.new)
      @article_repo = article_repo
    end

    def call(params)
      if params[:article_id]
        @article_id = params[:article_id].to_i
      end
      @articles = @article_repo.before_deadline
    end
  end
end
