module Api::Controllers::Meetings
  module Comments
    class Index
      include Api::Action

      params do
        required(:meeting_id) { filled? & int? & gt?(0) }
      end

      def initialize(json_repo: JsonRepository.new)
        @json_repo = json_repo
      end

      def call(params)
        if params.valid?
          meeting = @json_repo.find_meeting(params[:meeting_id])
          comments = @json_repo.comments_by_meeting(params[:meeting_id])

          self.body = JSON.pretty_generate({meeting: meeting.merge(comments: comments)})
          self.format = :json
        else
          self.status = 400
        end
      end
    end
  end
end
