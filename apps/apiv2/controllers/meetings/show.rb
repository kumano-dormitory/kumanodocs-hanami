module Apiv2::Controllers::Meetings
  class Show
    include Apiv2::Action
    accept :jsonapi

    params do
      required(:id) { filled? & int? & gt?(0) }
    end

    def initialize(json_repo: JsonRepository.new,
                   authenticator: JwtAuthenticator.new)
      @json_repo = json_repo
      @authenticator = authenticator
    end

    def call(params)
      if params.valid?
        meeting = @json_repo.find_meeting(params[:id])
        halt 404, '{}' unless meeting
        articles = @json_repo.articles_by_meeting(params[:id])
        json = JSON.generate({
          data: {
            type: 'meetings',
            id: meeting[:id],
            attributes: meeting.merge(articles: articles)
          }
        })
        self.body = json
        self.format = :jsonapi
      else
        self.body = '{}'
        self.status = 400
      end
    end
  end
end
