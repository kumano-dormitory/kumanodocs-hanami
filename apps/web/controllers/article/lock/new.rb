module Web::Controllers::Article::Lock
  class New
    include Web::Action
    expose :locked, :for_table, :table_id

    def initialize(article_repo: ArticleRepository.new)
      @article_repo = article_repo
    end

    def call(params)
      article = @article_repo.find_with_relations(params[:article_id])
      @locked = article.author.locked?
      @for_table = !params[:table_id].nil?
      @table_id = params[:table_id]
    end
  end
end
