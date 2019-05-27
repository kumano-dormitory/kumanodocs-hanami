module Api::Controllers::Articles
  class Index
    include Api::Action

    DEFAULT_WITH_ARTICLE_COUNT = 3

    params do
      required(:token).filled(:str?)
      optional(:with_articles) { filled? & int? & gt?(0) & lt?(6)}
    end

    def initialize(json_repo: JsonRepository.new)
      @json_repo = json_repo
    end

    def call(params)
      if params.valid?
        meetings = @json_repo.meetings_list(limit: 20)
        with_articles_count = params[:with_articles] || DEFAULT_WITH_ARTICLE_COUNT
        meetings.map!.with_index { |meeting, idx|
          if idx < with_articles_count
            articles = @json_repo.articles_by_meeting(meeting[:id])
            meeting.merge(articles: articles)
          else
            meeting
          end
        }
        self.body = JSON.pretty_generate({meetings: meetings})
        self.format = :json
      else
        self.status = 400
      end
    end
  end
end
