# ====
# ブロック会議一覧の表示アクション
# ====
# ブロック会議の一覧を表示する

module Web::Controllers::Meeting
  class Index
    include Web::Action
    expose :meetings

    def initialize(meeting_repo: MeetingRepository.new,
                   authenticator: JwtAuthenticator.new)
      @meeting_repo = meeting_repo
      @authenticator = authenticator
    end

    def call(params)
      @meetings = @meeting_repo.desc_by_date(limit: 20)
    end

    def navigation
      @navigation = {meeting: true, bn_meeting: true, enable_dark: true}
    end
  end
end
