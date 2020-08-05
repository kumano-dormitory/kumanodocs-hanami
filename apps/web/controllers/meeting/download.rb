# ====
# 一般向けページからのブロック会議資料PDFのダウンロードアクション
# ====
# ブロック会議資料PDFをダウンロードを行う
# ブロック会議が指定されていない場合は、ブロック会議を選択する画面を表示する
# = 主な処理
# - ブロック会議が指定されていない場合は、ブロック会議を選択するページを表示
# - ブロック会議が指定されている場合は、PDF生成サービスを用いてPDFを作成し、そのデータを返す

require 'fileutils'
require 'digest/md5'

module Web::Controllers::Meeting
  class Download
    include Web::Action
    expose :meetings, :tex_str

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
      if params.valid?
        # ブロック会議が指定されているのでPDFを返す
        @meeting = @meeting_repo.find(params[:id])
        specification = Specifications::Pdf.new(type: :web_articles, meeting_id: @meeting.id)
        result = @generate_pdf_interactor.call(specification)
        halt 500 if result.failure?

        self.format = :pdf
        self.headers.merge!({'Content-Disposition' => "attachment; filename=\"kumanodocs_meeting_#{@meeting.date}.pdf\""})
        unsafe_send_file Pathname.new(result.path)
      else
        # ブロック会議を指定する画面を表示する
        # TODO: 寮生大会は含めない
        @meetings = @meeting_repo.desc_by_date(limit: 20)
      end
    end

    def navigation
      @navigation = {download: true}
    end
  end
end
