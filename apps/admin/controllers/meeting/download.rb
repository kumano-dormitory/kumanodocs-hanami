require 'fileutils'
require 'digest/md5'

module Admin::Controllers::Meeting
  class Download
    include Admin::Action
    expose :meetings, :meeting, :tex_str, :view_type

    params do
      required(:id) { filled? & int? & gt?(0) }
      optional(:articles).filled(:bool?)
      optional(:comments).filled(:bool?)
    end

    def initialize(meeting_repo: MeetingRepository.new,
                   authenticator: AdminAuthenticator.new,
                   generate_pdf_interactor: GeneratePdf.new)
      @meeting_repo = meeting_repo
      @authenticator = authenticator
      @generate_pdf_interactor = generate_pdf_interactor
    end

    def call(params)
      if params.valid?
        @meeting = @meeting_repo.find(params[:id])
        if params[:articles]
          specification = Specifications::Pdf.new(meeting_id: @meeting.id, type: :admin_articles, after_6pm: after_6pm(@meeting))
          result = @generate_pdf_interactor.call(specification)
          halt 500 if result.failure?

          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "attachment; filename=\"kumanodocs_meeting_#{@meeting.date}.pdf\""})
          unsafe_send_file Pathname.new(result.path)
        elsif params[:comments]
          specification = Specifications::Pdf.new(type: :admin_comments, meeting_id: params[:id])
          result = @generate_pdf_interactor.call(specification)
          halt 500 if result.failure?

          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "attachment; filename=\"kumanodocs_comments_#{@meeting.date}.pdf\""})
          unsafe_send_file Pathname.new(result.path)
        else
          @view_type = :meeting
        end
      else
        @meetings = @meeting_repo.desc_by_date(limit: 20)
        @view_type = :meetings
      end
    end

    def after_6pm(meeting, now: Time.now)
      date = meeting.date
      meeting_date_6pm = Time.new(date.year, date.mon, date.day, 18,0,0,"+09:00")
      now > meeting_date_6pm
    end

    def navigation
      @navigation = {pdf: true}
    end
  end
end
