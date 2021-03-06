# ====
# 表の更新アクション
# ====
# 表を更新する
# 表の更新フローは以下の通りである
# 1. 表の更新に必要な項目が全て入力されていることを確認
# 2. 表が付随している議案について、パスワード認証が正しく行われていることを確認
# 3. 表がPDFとして出力できるかを、実際にPDFを生成することで確認
# 4. 上記のチェックを全て通った表のみが更新される
# チェックを通らなかった表については、エラーメッセージを表示して表の編集ページを再度表示する

module Web::Controllers::Table
  class Update
    include Web::Action
    expose :table, :confirm_update

    params do
      required(:id).filled(:int?)
      required(:table).schema do
        required(:get_lock).filled(:bool?)
        optional(:article_passwd).filled(:str?)
        required(:caption).filled(:str?)
        required(:tsv).filled(:str?)
      end
    end

    def initialize(table_repo: TableRepository.new,
                   author_repo: AuthorRepository.new,
                   generate_pdf_interactor: GeneratePdf.new,
                   authenticator: JwtAuthenticator.new)
      @table_repo = table_repo
      @author_repo = author_repo
      @generate_pdf_interactor = generate_pdf_interactor
      @authenticator = authenticator
      @notifications = {}
    end

    def call(params)
      if params.valid?
        article = @table_repo.find_with_relations(params[:id]).article

        if article.author.lock_key == cookies[:article_lock_key]
          # セッションが有効なので編集可
          if compile_check(params[:table][:caption], params[:table][:tsv])
            update(article, params)
          else
            @notifications = {error: {status: "Error", message: "入力された項目に不備があります. もう一度確認してください. Excelなどからコピー&ペーストした後、入力フォーム内で編集しないでください."}}
            self.status = 422
          end
        else
          if params[:table][:get_lock]
            # confirm_updateが有効
            if article.author.authenticate(params[:table][:article_passwd])
              # 認証が成功したので編集可
              if compile_check(params[:table][:caption], params[:table][:tsv])
                update(article, params)
              else
                @notifications = {error: {status: "Error", message: "入力された項目に不備があります. もう一度確認してください. Excelなどからコピー&ペーストした後、入力フォーム内で編集しないでください."}}
                self.status = 422
              end
            else
              @confirm_update = true
              @notifications = {error: {status: "Authentication Failed:", message: "パスワードが不正です. 正しいパスワードを入力してください"}}
              self.status = 401
            end
          else
            @confirm_update = true
          end
        end
      else
        @notifications = {error: {status: "Error", message: "入力された項目に不備があります. もう一度確認してください"}}
        self.status = 422
      end
      @table = @table_repo.find_with_relations(params[:id])
    end

    private
    def update(article, params)
      table_params = {
        caption: params[:table][:caption],
        csv: params[:table][:tsv]
      }
      @table_repo.update(params[:id], table_params)
      @author_repo.release_lock(article.author_id)
      flash[:notifications] = {success: {status: "Success", message: "正常に表が編集されました"}}
      redirect_to routes.article_path(id: article.id)
    end

    def compile_check(caption, tsv)
      specification = Specifications::Pdf.new(type: :table, data: {caption: caption, csv: tsv})
      result = @generate_pdf_interactor.call(specification)
      !result.failure?
    end

    def notifications
      @notifications
    end
  end
end
