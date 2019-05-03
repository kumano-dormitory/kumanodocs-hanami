module Api::Controllers::Articles
  class Show
    include Api::Action

    params do
      required(:id) { filled? & int? & gt?(0) }
    end

    def initialize(json_repo: JsonRepository.new)
      @json_repo = json_repo
    end

    def call(params)
      if params.valid?
        article = @json_repo.article_details(params[:id])
        halt 404 unless article
        self.body = JSON.pretty_generate({article: article})
        self.format = :json
      else
        self.status = 404
      end
    end
  end
end
