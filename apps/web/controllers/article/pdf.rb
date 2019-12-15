# ====
# 議案のプレビュー用PDF生成アクション
# ====
# 議案のプレビュー用PDFを生成し、PDFのデータを返す（HTMLではなくPDFを返す）
# = 主な処理
# - 指定された議案についてPDFを生成
# - 正常に生成された場合にはPDFデータを返す
# - 生成に失敗した場合は status 500

module Web::Controllers::Article
  class Pdf
    include Web::Action

    params do
      required(:id) { filled? & int? & gt?(0) }
    end

    # Dependency injection
    # authenticatorは認証モジュールで必須(../authentication.rb)
    def initialize(article_repo: ArticleRepository.new,
                   generate_pdf_interactor: GeneratePdf.new,
                   authenticator: JwtAuthenticator.new)
      @article_repo = article_repo
      @generate_pdf_interactor = generate_pdf_interactor
      @authenticator = authenticator
    end

    def call(params)
      halt 404 unless params.valid?

      # 議案が指定されているのでPDFを返す
      @article = @article_repo.find(params[:id])
      halt 404 unless @article
      # 生成するPDFの仕様を作成
      specification = Specifications::Pdf.new(type: :web_article_preview, article_id: @article.id)
      # PDF生成サービスを呼び出す
      result = @generate_pdf_interactor.call(specification)
      halt 500 if result.failure?

      self.format = :pdf
      self.headers.merge!({'Content-Disposition' => "inline"})
      unsafe_send_file Pathname.new(result.path)
    end
  end
end
