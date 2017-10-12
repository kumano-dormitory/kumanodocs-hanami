module Admin::Controllers::Meeting
  module Article
    class New
      include Admin::Action
      expose :meetings, :categories

      def initialize(meeting_repo: MeetingRepository.new,
                     category_repo: CategoryRepository.new)
        @meeting_repo = meeting_repo
        @category_repo = category_repo
      end

      def call(params)
        @meetings = @meeting_repo.in_time
        @categories = @category_repo.all
      end
    end
  end
end
