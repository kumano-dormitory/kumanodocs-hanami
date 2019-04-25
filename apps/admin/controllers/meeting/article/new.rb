module Admin::Controllers::Meeting
  module Article
    class New
      include Admin::Action
      expose :meeting, :categories

      def initialize(meeting_repo: MeetingRepository.new,
                     category_repo: CategoryRepository.new)
        @meeting_repo = meeting_repo
        @category_repo = category_repo
      end

      def call(params)
        @meeting = @meeting_repo.find(params[:meeting_id])
        @categories = @category_repo.all
      end
    end
  end
end
