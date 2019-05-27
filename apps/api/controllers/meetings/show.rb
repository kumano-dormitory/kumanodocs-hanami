module Api::Controllers::Meetings
  class Show
    include Api::Action
    accept :html, :json

    params do
      required(:token).filled(:str?)
      required(:id) { filled? & int? & gt?(0) }
    end

    def initialize(json_repo: JsonRepository.new)
      @json_repo = json_repo
    end

    def call(params)
      if params.valid?
        meeting = @json_repo.find_meeting(params[:id])
        halt 404 unless meeting
        articles = @json_repo.articles_by_meeting(params[:id])
        json = JSON.pretty_generate({meeting: meeting.merge(articles: articles)})
        self.body = json
        self.format = :json
      else
        self.status = 400
      end
    end
  end
end
