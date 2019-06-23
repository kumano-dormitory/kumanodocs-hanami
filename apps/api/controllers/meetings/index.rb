module Api::Controllers::Meetings
  class Index
    include Api::Action

    DEFAULT_LIMIT = 20
    MAX_LIMIT = 100

    params do
      optional(:token).filled(:str?)
      optional(:limit) { filled? & int? & gt?(0) }
      optional(:offset) { filled? & int? & gt?(0) }
    end

    def initialize(json_repo: JsonRepository.new)
      @json_repo = json_repo
    end

    def call(params)
      if params.valid?
        limit = params[:limit] || DEFAULT_LIMIT
        limit = MAX_LIMIT if limit > MAX_LIMIT
        offset = params[:offset] || 0

        meetings = @json_repo.meetings_list(limit: limit, offset: offset)
        self.body = JSON.pretty_generate({meetings: meetings})
        self.format = :json
      else
        self.status = 400
      end
    end
  end
end
