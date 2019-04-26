module Admin::Controllers::Meeting
  class Create
    include Admin::Action

    params do
      required(:meeting).schema do
        required(:date).filled(:date?)
        required(:deadline).filled(:date_time?)
      end
    end

    def initialize(meeting_repo: MeetingRepository.new)
      @meeting_repo = meeting_repo
      @notifications = {}
    end

    def call(params)
      if params.valid?
        meeting_attr = {
          date: params[:meeting][:date],
          deadline: params[:meeting][:deadline].to_s.gsub(/\+00:00/, "+09:00")
        }
        @meeting_repo.create(meeting_attr)

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
