module Web::Controllers::Comment
  class Index
    include Web::Action
    expose :meeting, :blocks, :during_meeting

    def initialize(meeting_repo: MeetingRepository.new,
                   block_repo: BlockRepository.new)
      @meeting_repo = meeting_repo
      @block_repo = block_repo
    end

    def call(params)
      @meeting = @meeting_repo.find(params[:meeting_id])
      @blocks = @block_repo.by_meeting_with_comment_vote_count(@meeting.id).reject{ |block| block[:id] > 9 }
      @during_meeting = during_meeting?
    end
  end
end
