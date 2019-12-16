module Web::Controllers::Table
  class Destroy
    include Web::Action
    expose :table

    params do
      required(:id).filled(:int?)
      optional(:table).schema do
        required(:article_passwd).filled(:str?)
        required(:confirm).filled(:bool?)
      end
    end

    def initialize(table_repo: TableRepository.new,
                   authenticator: JwtAuthenticator.new)
      @table_repo = table_repo
      @authenticator = authenticator
      @notifications = {}
    end

    def call(params)
      @table = @table_repo.find_with_relations(params[:id])

      if params.valid?
        if !params.dig(:table, :confirm).nil? && params.dig(:table, :confirm)
          if @table.article.author.authenticate(params[:table][:article_passwd])
            @table_repo.delete(params[:id])
            flash[:notifications] = {success: {status: "Success:", message: "正常に表が削除されました"}}
            redirect_to routes.article_path(id: table.article_id)
          else
            @notifications = {error: {status: "Authentication Failed:", message: "パスワードが間違っています. 正しいパスワードを入力してください"}}
            self.status = 401
          end
        end
      else
        @notifications = {error: {status: "Error:", message: "入力された項目に不備があります. もう一度確認してください"}}
        self.status = 422
      end
    end

    def notifications
      @notifications
    end
  end
end
