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
      @meetings = @meeting_repo.in_time
      @categories = @category_repo.all
      @article = @article_repo.find_with_author(params[:id])
    end
  end
end
