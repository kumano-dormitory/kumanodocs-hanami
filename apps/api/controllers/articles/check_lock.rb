module Api::Controllers::Articles
  class CheckLock
    include Api::Action

    params do
      optional(:token).filled(:str?)
      required(:id).filled(:int?)
    end

    def initialize(article_repo: ArticleRepository.new,
                   authenticator: JwtAuthenticator.new)
      @article_repo = article_repo
      @authenticator = authenticator
    end

    def call(params)
      self.format = :json
      if params.valid?
        article = @article_repo.find_with_relations(params[:id])
        self.status = 200
        self.body = "{\"response_code\":200,\"message\":\"OK\",\"response_body\":{\"id\":\"#{article.id}\",\"locked\":\"#{article.author.locked?}\"}}"
      else
        self.status = 422
        self.body = '{"response_code":422,"message":"Unprocessable Entity","response_body":{"status":"Error","message":"入力された項目に不備があります."}}'
      end
    end
  end
end
