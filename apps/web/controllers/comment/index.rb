# ====
# 議事録の投稿のブロック選択画面表示アクション
# ====
# 議事録の投稿を行うブロックを選択する画面を表示する
# デスクトップ（画面幅が十分に広い）ではこの画面には遷移せず、直接トップページでブロックを選択できる
# モバイル端末など画面幅が狭い場合に、議事録を投稿するブロックの選択を行うために、この画面に遷移するボタンが表示される

module Web::Controllers::Comment
  class Index
    include Web::Action
    expose :meeting, :blocks, :during_meeting

    def initialize(meeting_repo: MeetingRepository.new,
                   block_repo: BlockRepository.new,
                   authenticator: JwtAuthenticator.new)
      @meeting_repo = meeting_repo
      @block_repo = block_repo
      @authenticator = authenticator
    end

    def call(params)
      @meeting = @meeting_repo.find(params[:meeting_id])
      @blocks = @block_repo.by_meeting_with_comment_vote_count(@meeting.id).reject{ |block| block[:id] > 9 }
      @during_meeting = during_meeting?
    end
  end
end
