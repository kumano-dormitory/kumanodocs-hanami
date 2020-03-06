module Api::Controllers::Articles
  class GetLock
    include Api::Action

    params do
      optional(:token).filled(:str?)
      required(:id).filled(:int?)
      required(:password).filled(:str?)
    end

    def initialize(article_repo: ArticleRepository.new,
                   author_repo: AuthorRepository.new,
                   authenticator: JwtAuthenticator.new)
      @article_repo = article_repo
      @author_repo = author_repo
      @authenticator = authenticator
    end

    def call(params)
      self.format = :json
      article = @article_repo.find_with_relations(params[:id])
      if params.valid?
        if article.author.authenticate(params[:password])
          lock_key = @author_repo.lock(article.author_id, params[:password])
          self.body = "{\"response_code\":200,\"message\":\"OK\",\"response_body\":{\"status\":\"Success\",\"message\":\"正常に認証されました.\",\"lock_key\":\"#{lock_key}\"}}"
          self.status = 200
        else
          self.body = '{"response_code":403,"message":"Forbidden","response_body":{"status":"Error","message":"パスワードが不正です. 正しいパスワードを入力してください."}}'
          self.status = 403
        end
      else
        self.body = '{"response_code":422,"message":"Unprocessable Entity","response_body":{"status":"Error","message":"入力された項目に不備があり認証できません."}}'
        self.status = 422
      end
    end
  end
end
