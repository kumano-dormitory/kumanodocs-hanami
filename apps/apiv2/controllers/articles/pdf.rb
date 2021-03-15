module Apiv2::Controllers::Articles
  class Pdf
    include Apiv2::Action

    params do
      required(:id) { filled? & int? & gt?(0) }
    end

    def initialize(article_repo: ArticleRepository.new,
                   generate_pdf_interactor: GeneratePdf.new,
                   authenticator: JwtAuthenticator.new)
      @article_repo = article_repo
      @generate_pdf_interactor = generate_pdf_interactor
      @authenticator = authenticator
    end

    def call(params)
      halt 404, '{"errors":[{"status":"404","title":"Not Found"}]}' unless params.valid?

      # 議案が指定されているのでPDFを返す
      @article = @article_repo.find(params[:id])
      halt 404, '{"errors":[{"status":"404","title":"Not Found"}]}' unless @article
      # 生成するPDFの仕様を作成
      specification = Specifications::Pdf.new(type: :web_article_preview, article_id: @article.id)
      # PDF生成サービスを呼び出す
      result = @generate_pdf_interactor.call(specification)
      halt 500, '{"errors":[{"status":"500","title":"Internal Server Error"}]}' if result.failure?

      self.format = :pdf
      self.headers.merge!({'Content-Disposition' => "inline"})
      unsafe_send_file Pathname.new(result.path)
    end
  end
end
