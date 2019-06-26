module Api::Controllers::Meetings
  class Past
    include Api::Action

    params do
      optional(:token).filled(:str?)
      required(:id).filled(:int?)
    end

    def initialize(json_repo: JsonRepository.new)
      @json_repo = json_repo
    end

    def call(params)
      if params.valid?
        past_meeting = @json_repo.find_past_meeting(params[:id])
        halt 404 unless past_meeting
        json = JSON.pretty_generate({meeting: past_meeting})
        self.body = json
        self.format = :json
      else
        self.status = 400
      end
    end
  end
end
