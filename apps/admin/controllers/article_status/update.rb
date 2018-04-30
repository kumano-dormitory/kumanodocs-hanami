module Admin::Controllers::ArticleStatus
  class Update
    include Admin::Action
    expose :meeting

    params do
      required(:meeting).schema do
        required(:articles) do
          array? do
            each do
              hash?
              # FIX ME: hash?　中身までバリデーションをする
            end
          end
        end
      end
      required(:id).filled(:int?)
    end

    def initialize(meeting_repo: MeetingRepository.new,
                   article_repo: ArticleRepository.new)
      @meeting_repo = meeting_repo
      @article_repo = article_repo
    end

    def call(params)
      if params.valid?
        articles_status = params[:meeting][:articles]
        @article_repo.update_status(articles_status)
        redirect_to routes.meeting_path(id: params[:id])
      else
        @meeting = @meeting_repo.find_with_articles(params[:id])
        self.status = 422
      end
    end
  end
end
