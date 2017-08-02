module Admin::Controllers::Prepare
  class Select
    include Admin::Action
    expose :articles

    def initialize(article_repo: ArticleRepository.new)
      @article_repo = article_repo
    end

    def call(params)
      @articles = @article_repo.by_meeting(params[:id])
    end
  end
end
