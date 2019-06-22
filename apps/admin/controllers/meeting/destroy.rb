module Admin::Controllers::Meeting
  class Destroy
    include Admin::Action
    expose :meeting

    params do
      required(:meeting).schema do
        required(:confirm).filled(:bool?)
      end
    end

    def initialize(meeting_repo: MeetingRepository.new,
                   admin_histroy_repo: AdminHistoryRepository.new)
      @meeting_repo = meeting_repo
      @admin_histroy_repo = admin_histroy_repo
    end

    def call(params)
      @meeting = @meeting_repo.find(params[:id])
      if params.valid?
        @meeting_repo.delete(params[:id])
        @admin_histroy_repo.add(:meeting_destroy, JSON.pretty_generate({action: "meeting_destroy", payload: {meeting: @meeting.to_h} }))
        flash[:notifications] = {success: {status: "Success:", message: "正常に#{@meeting.date}のブロック会議日程が削除されました"}}
        redirect_to routes.meetings_path
      end
    end
  end
end
