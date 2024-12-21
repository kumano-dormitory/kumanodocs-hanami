module Admin::Controllers::Meeting
  class Create
    include Admin::Action

    params do
      required(:meeting).schema do
        required(:date).filled(:date?)
        required(:deadline).filled(:date_time?)
        required(:ryoseitaikai).filled(:bool?)
        required(:daigiinkai).filled(:bool?)
        required(:ryoseishukai).filled(:bool?)
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
      if params.valid? && valid_deadline?(params)
        meeting_attr = {
          date: params[:meeting][:date],
          deadline: params[:meeting][:deadline].to_s.gsub(/\+00:00/, "+09:00"),
          #特別な会議かどうか
          type: 
          if (params[:meeting][:ryoseitaikai] == TRUE) then
            1
          elsif(params[:meeting][:daigiinkai] == TRUE) then
            2
          elsif(params[:meeting][:ryoseishukai] == TRUE) then
            3
          else
            0
          end
          #type: (params[:meeting][:ryoseitaikai] ? 1 : 0)
        }
        meeting = @meeting_repo.create(meeting_attr)
        @admin_history_repo.add(:meeting_create, JSON.pretty_generate({action: "meeting_create", payload: {meeting: meeting.to_h} }))

        flash[:notifications] = {success: {status: "Success:", message: "正常にブロック会議日程が作成されました"}}
        redirect_to routes.meetings_path
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
