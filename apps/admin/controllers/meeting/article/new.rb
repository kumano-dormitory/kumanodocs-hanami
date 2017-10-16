module Admin::Controllers::Meeting
  module Article
    class New
      include Admin::Action

      def initialize(meeting_repo: MeetingRepository.new,
                     category_repo: CategoryRepository.new)
        @meeting_repo = meeting_repo
        @category_repo = category_repo
      end

      def call(params)
      end
    end
  end
end
