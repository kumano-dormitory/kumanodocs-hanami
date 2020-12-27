# ====
# ブロック会議一覧の表示アクション
# ====
# ブロック会議の一覧を表示する

module Web::Controllers::Meeting
  class Index
    include Web::Action
    expose :meetings, :page, :max_page

    params do
      optional(:page).filled(:int?)
    end

    def initialize(meeting_repo: MeetingRepository.new,
                   authenticator: JwtAuthenticator.new,
                   limit: 20)
      @meeting_repo = meeting_repo
      @authenticator = authenticator
      @limit = 20
    end

    def call(params)
      if params.valid?
        @page = params[:page].nil? ? 1 : params[:page]
        @meetings = @meeting_repo.desc_by_date(limit: @limit, offset: (@limit * (@page - 1)))
      else
        @page = 1
        @meetings = @meeting_repo.desc_by_date(limit: @limit)
      end
      @max_page = (@meeting_repo.count - 1) / @limit + 1
    end

    def navigation
      @navigation = {meeting: true, bn_meeting: true, enable_dark: true}
    end
  end
end
