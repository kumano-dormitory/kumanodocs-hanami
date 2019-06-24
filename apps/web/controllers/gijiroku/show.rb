module Web::Controllers::Gijiroku
  class Show
    include Web::Action
    expose :gijiroku

    def initialize(gijiroku_repo: GijirokuRepository.new)
      @gijiroku_repo = gijiroku_repo
    end

    def call(params)
      @gijiroku = @gijiroku_repo.find(params[:id])
    end
  end
end
