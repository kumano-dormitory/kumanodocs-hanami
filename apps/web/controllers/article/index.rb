module Web::Controllers::Article
  class Index
    include Web::Action
    expose :articles_by_meeting

    def initialize(article_repo: ArticleRepository.new)
      @article_repo = article_repo
    end

    def call(_params)
      @articles_by_meeting = @article_repo.group_by_meeting
    end
  end
end
