module Web::Controllers::Article
  class Index
    include Web::Action
    expose :articles_by_meeting

    def initialize(article_repository: ArticleRepository.new)
      @article_repository = article_repository
    end

    def call(params)
      @articles_by_meeting = @article_repository.by_meeting
    end
  end
end
