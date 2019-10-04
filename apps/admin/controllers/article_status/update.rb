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
                   article_repo: ArticleRepository.new,
                   admin_history_repo: AdminHistoryRepository.new,
                   authenticator: AdminAuthenticator.new)
      @meeting_repo = meeting_repo
      @article_repo = article_repo
      @admin_history_repo = admin_history_repo
      @authenticator = authenticator
      @notifications
    end

    def call(params)
      if params.valid?
        articles_status = params[:meeting][:articles]
        @article_repo.update_status(articles_status)
        @admin_history_repo.add(:article_status_update,
          JSON.pretty_generate({action:"article_status_update", payload: {meeting_id: params[:id], articles_status: articles_status}})
        )
        flash[:notifications] = {success: {status: "Success:", message: "正常に通常議案フラグの変更が行われました"}}
        redirect_to routes.meeting_path(id: params[:id])
      else
        @meeting = @meeting_repo.find_with_articles(params[:id])
        @notifications = {error: {status: "Error:", message: "入力された項目に不備があります. もう一度確認してください"}}
        self.status = 422
      end
    end

    def notifications
      @notifications
    end
  end
end
