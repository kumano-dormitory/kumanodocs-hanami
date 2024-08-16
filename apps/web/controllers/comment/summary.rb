module Web::Controllers::Comment
  class Summary
    include Web::Action
    expose :meetings, :meeting, :comments, :messages, :max_page, :page

    def initialize(meeting_repo: MeetingRepository.new,
                   comment_repo: CommentRepository.new,
                   message_repo: MessageRepository.new,
                   authenticator: JwtAuthenticator.new)
      @meeting_repo = meeting_repo
      @comment_repo = comment_repo
      @message_repo = message_repo
      @authenticator = authenticator
    end

    def call(params)
      @meetings = @meeting_repo.desc_by_date(limit: 15).filter{ |m| m.date > Date.new(2022,6,19) && m.date < Date.new(2022,12,15) }

      @page = params[:page]&.to_i || 0
      @page = 0 if @page < 0
      @page = (@meetings.length - 1) if @page > (@meetings.length - 1)

      @meeting = @meetings[@page]

      # ブロック会議の０番（前回のブロック会議から）
      @comments = @comment_repo.by_meeting(@meeting.id)
                                    .group_by{|comment| comment[:article_id]}
      @messages = @message_repo.by_meeting(@meeting.id)
                                    .group_by{|message| message[:comment_id]}


      @max_page = @meetings.length - 1
    end

    def navigation
      @navigation = {enable_dark: true}
    end
  end
end
