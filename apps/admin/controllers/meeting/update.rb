module Admin::Controllers::Meeting
  class Update
    include Admin::Action
    expose :meeting

    params do
      required(:id).filled(:int?)
      required(:meeting).schema do
        required(:date).filled(:date?)
        required(:deadline).filled(:date_time?)
        required(:ryoseitaikai).filled(:bool?)
      end
    end

    def initialize(meeting_repo: MeetingRepository.new,
                   admin_history_repo: AdminHistoryRepository.new,
                   authenticator: AdminAuthenticator.new)
      @meeting_repo = meeting_repo
      @admin_history_repo = admin_history_repo
      @authenticator = authenticator
      @notifications = {}
    end

    def call(params)
      @meeting = @meeting_repo.find(params[:id])
      if params.valid? && valid_deadline?(params)
        meeting_attr = {
          date: params[:meeting][:date],
          deadline: params[:meeting][:deadline].to_s.gsub(/\+00:00/, "+09:00"),
          type: (params[:meeting][:ryoseitaikai] ? 1 : 0)
        }
        meeting = @meeting_repo.update(@meeting.id, meeting_attr)
        @admin_history_repo.add(:meeting_update,
          JSON.pretty_generate({action: "meeting_update", payload: {meeting_before: @meeting.to_h, meeting_after: meeting.to_h}})
        )
        flash[:notifications] = {success: {status: "Success:", message: "正常にブロック会議日程が編集されました"}}
        redirect_to routes.meeting_path(id: @meeting.id)
      else
        @notifications = {error: {status: "Error:", message: "入力された項目に不備があります. もう一度確認してください"}}
        self.status = 422
      end
    end

    private
    def valid_deadline?(params)
      date = params[:meeting][:date]
      deadline = DateTime.parse(params[:meeting][:deadline].to_s.gsub(/\+00:00/, "+09:00"))
      meeting_date = Time.new(date.year, date.month, date.day, 22, 0, 0, "+09:00")
      meeting_deadline = deadline.to_time
      meeting_deadline <= meeting_date
    end

    def notifications
      @notifications
    end
  end
end
