module Apiv2::Controllers::Meetings
  class Pdf
    include Apiv2::Action

    params do
      required(:id) { filled? & int? & gt?(0) }
    end

    def initialize(meeting_repo: MeetingRepository.new,
                   generate_pdf_interactor: GeneratePdf.new,
                   authenticator: JwtAuthenticator.new)
      @meeting_repo = meeting_repo
      @generate_pdf_interactor = generate_pdf_interactor
      @authenticator = authenticator
    end

    def call(params)
      halt 404, '{"errors":[{"status":"404","title":"Not Found"}]}' unless params.valid?

      # 議案が指定されているのでPDFを返す
      @meeting = @meeting_repo.find(params[:id])
      halt 404, '{"errors":[{"status":"404","title":"Not Found"}]}' unless @meeting
      # 生成するPDFの仕様を作成
      specification = Specifications::Pdf.new(type: :web_articles, meeting_id: @meeting.id)
      # PDF生成サービスを呼び出す
      result = @generate_pdf_interactor.call(specification)
      halt 500, '{"errors":[{"status":"500","title":"Internal Server Error"}]}' if result.failure?

      self.format = :pdf
      self.headers.merge!({'Content-Disposition' => "attachment; filename=\"kumanodocs_meeting_#{@meeting.date}.pdf\""})
      unsafe_send_file Pathname.new(result.path)
    end
  end
end
