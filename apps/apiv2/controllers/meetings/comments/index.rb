module Apiv2::Controllers::Meetings
  module Comments
    class Index
      include Apiv2::Action
      params do
        optional(:token).filled(:str?)
        required(:meeting_id) { filled? & int? & gt?(0) }
      end

      def initialize(jsonapi_repo: JsonapiRepository.new,
                     authenticator: JwtAuthenticator.new)
        @jsonapi_repo = jsonapi_repo
        @authenticator = authenticator
      end

      def call(params)
        if params.valid?
          meeting = @jsonapi_repo.find_meeting(params[:meeting_id])
          comments = @jsonapi_repo.comments_by_meeting(params[:meeting_id])
          messages = @jsonapi_repo.messages_by_meeting(params[:meeting_id])

          ret = {
            id: meeting.id,
            type: 'meetings',
            attributes: meeting.merge(comments: comments).merge(messages: messages)
          }
          self.body = JSON.generate({
            data: ret
          })
          self.format = :jsonapi
        else
          self.body = '{}'
          self.status = 400
        end
      end
    end
  end
end
