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
    end

    def call(params)
      if params.valid?
        @meeting_repo.create(params[:meeting])

        redirect_to routes.meetings_path
      else
        self.status = 422
      end
    end
  end
end
