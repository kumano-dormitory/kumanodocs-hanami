# ====
# 表の新規投稿アクション
# ====
# 表を新規作成する
# 表の新規作成フローは以下のとおりである
# 1. 表の新規作成に必要な項目が全て入力されているかチェック(validation)
# 2. 表を新規追加する議案について、ブロック会議の投稿締め切りを過ぎていないか判定
# 3. 表のデータ(TSV形式)がTSVとしてパースできる正しい形式であるかを判定
# 4. 表の新規追加時に必要となる議案のパスワードが正しいか認証
# 5. 表がPDFとして出力できるかを、実際にPDFを生成することで確認
# 6. 上記すべてのチェックを通った表のみが新規作成される
# チェックに通らなかった表についてはエラーメッセージを表示して、表の新規投稿画面を再度表示する

require 'csv'

module Web::Controllers::Table
  class Create
    include Web::Action
    expose :articles

    params do
      required(:table).schema do
        required(:article_id).filled(:int?)
        required(:article_passwd).filled(:str?)
        required(:caption).filled(:str?)
        required(:tsv).filled(:str?)
      end
    end

    def initialize(article_repo: ArticleRepository.new,
                   author_repo: AuthorRepository.new,
                   table_repo: TableRepository.new,
                   generate_pdf_interactor: GeneratePdf.new,
                   authenticator: JwtAuthenticator.new)
      @article_repo = article_repo
      @author_repo = author_repo
      @table_repo = table_repo
      @generate_pdf_interactor = generate_pdf_interactor
      @authenticator = authenticator
      @notifications = {}
    end

    def call(params)
      if params.valid?
        article = @article_repo.find_with_relations(params[:table][:article_id])
        # 議案が締め切りを過ぎていないか、または締め切り後かつ追加議案であるかを判定
        meeting_date = Time.new(article.meeting.date.year, article.meeting.date.mon, article.meeting.date.day,22,0,0,"+09:00")
        if (article.meeting.deadline > Time.now) || \
           (after_deadline? && meeting_date > Time.now && !article.checked && !article.printed)
          begin
            CSV.parse(params[:table][:tsv], col_sep: "\t")
            if article.author.authenticate(params[:table][:article_passwd])
              if compile_check(params[:table][:caption], params[:table][:tsv])
                save_table(params, article)
                flash[:notifications] = {success: {status: "Success:", message: "正常に表が議案に追加されました"}}
                redirect_to routes.article_path(id: params[:table][:article_id])
              else
                @notifications = {error: {status: "Error", message: "入力された表の形式が不正です. 入力をやり直してください. Excelなどからコピー&ペーストした後、入力フォーム内で編集しないでください."}}
                self.status = 422
              end
            else
              @notifications = {error: {status: "Authentication Failed:", message: "議案のパスワードが間違っています. 正しいパスワードを入力してください"}}
              self.status = 401
            end
          rescue CSV::MalformedCSVError
            @notifications = {error: {status: "Error:", message: "入力された表の形式が不正です. 入力をやり直してください"}}
            self.status = 422
          end
        else
          @notifications = {error: {status: "Error:", message: "表を追加しようとした議案はすでに締め切り日時を過ぎているため編集できません. 必要があれば資料委員会に相談してください"}}
          self.status = 422
        end
      else
        @notifications = {error: {status: "Error:", message: "入力された項目に不備があります. もう一度確認してください"}}
        self.status = 422
      end

      @articles = @article_repo.before_deadline
    end

    def notifications
      @notifications
    end

    private
    def save_table(params, article)
      @table_repo.create(
        article_id: params[:table][:article_id],
        caption: params[:table][:caption],
        csv: params[:table][:tsv],
      )
      @author_repo.release_lock(article.author_id)
    end

    # PDFを指定されたパラメータで生成できるか判定するメソッド
    def compile_check(caption, tsv)
      specification = Specifications::Pdf.new(type: :table, data: {caption: caption, csv: tsv})
      # PDF生成サービスを使用する (lib/kumanodocs_hanami/interactors/generate_pdf.rb)
      result = @generate_pdf_interactor.call(specification)
      !result.failure?
    end
  end
end
