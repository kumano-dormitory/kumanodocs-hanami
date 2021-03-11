module Apiv2::Controllers::Meetings
  class Index
    include Apiv2::Action
    accept :jsonapi

    DEFAULT_LIMIT = 20
    MAX_LIMIT = 100

    params do
      optional(:limit) { filled? & int? & gt?(0) }
      optional(:offset) { filled? & int? & gteq?(0) }
    end

    def initialize(jsonapi_repo: JsonapiRepository.new,
                   authenticator: JwtAuthenticator.new)
      @jsonapi_repo = jsonapi_repo
      @authenticator = authenticator
    end

    def call(params)
      if params.valid?
        limit = params[:limit] || DEFAULT_LIMIT
        limit = MAX_LIMIT if limit > MAX_LIMIT
        offset = params[:offset] || 0

        meetings = @jsonapi_repo.meetings_list(limit: limit, offset: offset).map do |meeting|
          {
            type: 'meetings',
            id: meeting[:id],
            attributes: meeting
          }
        end
        self.body = JSON.generate({
          data: meetings
        })
        self.format = :jsonapi
      else
        self.body = '{}'
        self.status = 400
      end
    end
  end
end
