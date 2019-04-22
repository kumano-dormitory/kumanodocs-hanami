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
                   table_repo: TableRepository.new)
      @article_repo = article_repo
      @table_repo = table_repo
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
              flash[:notifications] = {success: {status: "Success:", message: "正常に表が議案に追加されました"}}
              redirect_to routes.article_path(id: params[:table][:article_id])
            end
          rescue CSV::MalformedCSVError
            @articles = @article_repo.before_deadline
            self.status = 422
          end
        end
      end
      @articles = @article_repo.before_deadline
      self.status = 422
    end
  end
end
