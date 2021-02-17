module Apiv2::Controllers::Articles
  class Index
    include Apiv2::Action
    accept :jsonapi

    DEFAULT_WITH_MEETING_COUNT = 3

    params do
      optional(:meeting_count) { filled? & int? & gt?(0) & lt?(6)}
    end

    def initialize(jsonapi_repo: JsonapiRepository.new,
                   authenticator: JwtAuthenticator.new)
      @jsonapi_repo = jsonapi_repo
      @authenticator = authenticator
    end

    def call(params)
      if params.valid?
        meetings = @jsonapi_repo.meetings_list(limit: 6)
        meeting_count = params[:meeting_count] || DEFAULT_WITH_MEETING_COUNT
        data = meetings.map.with_index { |meeting, idx|
          if idx < meeting_count
            @jsonapi_repo.articles_by_meeting(meeting[:id]).map do |article|
              {
                type: 'articles',
                id: article[:id],
                attributes: article.merge({
                  meeting_id: meeting[:id],
                  meeting_date: meeting[:date],
                  meeting_deadline: meeting[:deadline],
                  meeting_type: meeting[:type]
                })
              }
            end
          else
            []
          end
        }.reduce { |ret, item| ret.concat(item) }
        self.body = JSON.generate({
          data: data
        })
        self.format = :jsonapi
      else
        self.body = '{}'
        self.format = :jsonapi
        self.status = 400
      end
    end
  end
end
