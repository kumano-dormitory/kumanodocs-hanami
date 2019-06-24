module Api::Controllers::Gijiroku
  class Index
    include Api::Action

    params do
      optional(:token).filled(:str?)
    end

    def initialize(json_repo: JsonRepository.new)
      @json_repo = json_repo
    end

    def call(params)
      gijiroku = @json_repo.latest_gijiroku
      self.body = JSON.pretty_generate(gijiroku)
      self.format = :json
    end
  end
end
