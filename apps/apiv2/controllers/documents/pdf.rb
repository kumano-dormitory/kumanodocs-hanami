module Apiv2::Controllers::Documents
  class Pdf
    include Apiv2::Action

    params do
      required(:id) { filled? & int? & gt?(0) }
    end

    def initialize(document_repo: DocumentRepository.new,
                   authenticator: JwtAuthenticator.new)
      @document_repo = document_repo
      @authenticator = authenticator
    end

    def call(params)
      halt 404, '{"errors":[{"status":"404","title":"Not Found"}]}' unless params.valid?

      # 議案が指定されているのでPDFを返す
      @document = @document_repo.find(params[:id])
      if !@document || @document.type != 1
        halt 404, '{"errors":[{"status":"404","title":"Not Found"}]}'
      end
      if !FileTest.exist?("./docs/id#{@document.id}/#{@document.body}")
        halt 500, '{"errors":[{"status":"500","title":"Internal Server Error"}]}'
      end

      self.format = :pdf
      self.headers.merge!({'Content-Disposition' => "attachment; filename=\"kumanodocs_document_#{@document.id}.pdf\""})
      unsafe_send_file Pathname.new("./docs/id#{@document.id}/#{@document.body}")
    end
  end
end
