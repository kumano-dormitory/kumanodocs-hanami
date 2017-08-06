module Admin::Controllers::ArticleNumber
  class Update
    include Admin::Action
    expose :meeting
    expose :articles

    params do
      required(:meeting).schema do
        required(:articles) { array? { each { hash? }}}
      end
    end

    def initialize(meeting_repo: MeetingRepository.new,
                   article_repo: ArticleRepository.new)
      @meeting_repo = meeting_repo
      @article_repo = article_repo
    end

    def call(params)
      if params.valid?
        articles_number = params[:meeting][:articles]
        @article_repo.update_number(articles_number)
        redirect_to routes.meeting_path(id: params[:id])
      else
        @meeting = @meeting_repo.find_with_articles(params[:id])
      end
    end
  end
end
