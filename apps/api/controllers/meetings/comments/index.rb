module Api::Controllers::Meetings
  module Comments
    class Index
      include Api::Action

      params do
        optional(:token).filled(:str?)
        required(:meeting_id) { filled? & int? & gt?(0) }
      end

      def initialize(json_repo: JsonRepository.new,
                     authenticator: JwtAuthenticator.new)
        @json_repo = json_repo
        @authenticator = authenticator
      end

      def call(params)
        if params.valid?
          meeting = @json_repo.find_meeting(params[:meeting_id])
          comments = @json_repo.comments_by_meeting(params[:meeting_id])
          messages = @json_repo.messages_by_meeting(params[:meeting_id])

          self.body = JSON.pretty_generate({meeting: meeting.merge(comments: comments).merge(messages: messages)})
          self.format = :json
        else
          self.status = 400
        end
      end
    end
  end
end
