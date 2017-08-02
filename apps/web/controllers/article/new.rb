module Web::Controllers::Article
  class New
    include Web::Action
    expose :meetings, :categories

    def initialize(meeting_repository: MeetingRepository.new,
                   category_repository: CategoryRepository.new)
      @meeting_repository = meeting_repository
      @category_repository = category_repository
    end

    def call(_params)
      @meetings = @meeting_repository.in_time
      @categories = @category_repository.all
    end
  end
end
