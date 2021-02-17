module Apiv2::Controllers::Meetings
  class Past
    include Apiv2::Action

    params do
      required(:id).filled(:int?)
      optional(:withComments).filled(:bool?)
    end

    def initialize(jsonapi_repo: JsonapiRepository.new,
                   authenticator: JwtAuthenticator.new)
      @jsonapi_repo = jsonapi_repo
      @authenticator = authenticator
    end

    def call(params)
      if params.valid?
        past_meeting = @jsonapi_repo.find_past_meeting(params[:id])
        halt 404 unless past_meeting
        if (params[:withComments])
          comments = @jsonapi_repo.comments_by_meeting(past_meeting[:id])
          messages = @jsonapi_repo.messages_by_meeting(past_meeting[:id])
          past_meeting.merge!({comments: comments, messages: messages})
        end

        data = {
          id: past_meeting[:id],
          type: 'meetings',
          attributes: past_meeting
        }

        self.body = JSON.generate({data: data})
        self.format = :jsonapi
      else
        self.body = '{}'
        self.status = 400
      end
    end
  end
end
