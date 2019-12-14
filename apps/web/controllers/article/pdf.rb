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
      specification = Specifications::Pdf.new(type: :web_article_preview, article_id: @article.id)
      result = @generate_pdf_interactor.call(specification)
      halt 500 if result.failure?

      self.format = :pdf
      self.headers.merge!({'Content-Disposition' => "inline"})
      unsafe_send_file Pathname.new(result.path)
    end
  end
end
