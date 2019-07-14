module Admin::Controllers::ArticleNumber
  class Edit
    include Admin::Action
    expose :meeting, :for_download

    def initialize(meeting_repo: MeetingRepository.new,
                   authenticator: AdminAuthenticator.new)
      @meeting_repo = meeting_repo
      @authenticator = authenticator
    end

    def call(params)
      @meeting = @meeting_repo.find_with_articles(params[:id])
      @for_download = params[:download] || false
      self.headers.merge!({
        'Content-Security-Policy' => "form-action 'self'; frame-ancestors 'self'; base-uri 'self'; default-src 'none'; manifest-src 'self'; script-src 'self' https://ajax.googleapis.com/ajax/libs/jquery/ https://ajax.googleapis.com/ajax/libs/jqueryui/; connect-src 'self'; img-src 'self' https: data:; style-src 'self' 'unsafe-inline' https:; font-src 'self'; object-src 'none'; plugin-types application/pdf; child-src 'self'; frame-src 'self'; media-src 'self'"
      })
    end

    def navigation
      @navigation = {pdf: @for_download}
    end
  end
end
