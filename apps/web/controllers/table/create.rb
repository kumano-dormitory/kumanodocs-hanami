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
                   table_repo: TableRepository.new)
      @article_repo = article_repo
      @author_repo = author_repo
      @table_repo = table_repo
      @notifications = {}
    end

    def call(params)
      if params.valid?
        article = @article_repo.find_with_relations(params[:table][:article_id])
        if (article.meeting.deadline > Time.now)
          begin
            CSV.parse(params[:table][:tsv], col_sep: "\t")
            if article.author.authenticate(params[:table][:article_passwd])
              @table_repo.create(
                article_id: params[:table][:article_id],
                caption: params[:table][:caption],
                csv: params[:table][:tsv],
              )
              @author_repo.release_lock(article.author_id)
              flash[:notifications] = {success: {status: "Success:", message: "正常に表が議案に追加されました"}}
              redirect_to routes.article_path(id: params[:table][:article_id])
            else
              @notifications = {error: {status: "Authentication Failed:", message: "議案のパスワードが間違っています. 正しいパスワードを入力してください"}}
            end
          rescue CSV::MalformedCSVError
            @notifications = {error: {status: "Error:", message: "入力された表の形式が不正です. 入力をやり直してください"}}
          end
        else
          @notifications = {error: {status: "Error:", message: "表を追加しようとした議案はすでに締め切り日時を過ぎているため編集できません. 必要があれば資料委員会に相談してください"}}
        end
      else
        @notifications = {error: {status: "Error:", message: "入力された項目に不備があります. もう一度確認してください"}}
      end
      @articles = @article_repo.before_deadline
      self.status = 422
    end

    def notifications
      @notifications
    end
  end
end
