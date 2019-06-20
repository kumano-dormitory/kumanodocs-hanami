module Web::Controllers::Article
  class Top
    include Web::Action
    expose :save_token, :during_meeting, :next_meeting, :blocks

    def initialize(meeting_repo: MeetingRepository.new,
                   block_repo: BlockRepository.new)
      @meeting_repo = meeting_repo
      @block_repo = block_repo
    end

    def call(params)
      @next_meeting = @meeting_repo.find_most_recent
      # 議事録作成リンクの表示
      if during_meeting?
        @during_meeting = true
        @blocks = @block_repo.by_meeting_with_comment_vote_count(@next_meeting.id).reject{ |block| block[:id] > 9 }
      end

      # PWAからログインした場合にtokenをlocalstorageに保存する
      @save_token = !!params[:loggedin]
    end

    def navigation
      @navigation = {root: true}
    end
  end
end
