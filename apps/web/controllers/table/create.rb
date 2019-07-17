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
                   authenticator: JwtAuthenticator.new)
      @article_repo = article_repo
      @author_repo = author_repo
      @table_repo = table_repo
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
              save_table(params, article)
              flash[:notifications] = {success: {status: "Success:", message: "正常に表が議案に追加されました"}}
              redirect_to routes.article_path(id: params[:table][:article_id])
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

      if after_deadline?
        # 締め切り後なので追加議案にのみ表が追加できる
        @articles = @article_repo.not_checked_for_next_meeting
      else
        # 締め切り前なので、締切を過ぎていない議案全てに表が投稿できる
        @articles = @article_repo.before_deadline
      end
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
  end
end
