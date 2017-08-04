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
      Hanami.logger.info params[:meeting].inspect
      if params.valid?
        params[:meeting][:articles].each do |params_hash|
          @article_repo.update_number(params_hash)
        end
        redirect_to routes.meeting_path(id: params[:id])
      else
        @meeting = @meeting_repo.find(params[:id])
        @articles = @article_repo.by_meeting(params[:id])
      end
    end
  end
end
