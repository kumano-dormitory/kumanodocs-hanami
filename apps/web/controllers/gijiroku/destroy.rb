module Web::Controllers::Gijiroku
  class Destroy
    include Web::Action

    def initialize(gijiroku_repo: GijirokuRepository.new)
      @gijiroku_repo = gijiroku_repo
    end

    def call(params)
      gijiroku = @gijiroku_repo.find(params[:id])
      @gijiroku_repo.delete(gijiroku.id)
      redirect_to routes.gijirokus_path
    end
  end
end
