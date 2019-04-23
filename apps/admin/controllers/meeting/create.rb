module Admin::Controllers::Meeting
  class Create
    include Admin::Action

    params do
      required(:meeting).schema do
        required(:date).filled(:date?)
        required(:deadline).filled
      end
    end

    def initialize(meeting_repo: MeetingRepository.new)
      @meeting_repo = meeting_repo
      @notifications = {}
    end

    def call(params)
      if params.valid?
        @meeting_repo.create(params[:meeting])

        flash[:notifications] = {success: {status: "Success:", message: "正常にブロック会議日程が作成されました"}}
        redirect_to routes.meetings_path
      else
        @notifications = {error: {status: "Error:", message: "入力された項目に不備があります. もう一度確認してください"}}
        self.status = 422
      end
    end

    def notifications
      @notifications
    end
  end
end
