require 'csv'

module Admin::Controllers::Meeting
  module Article
    module Table
      class Create
        include Admin::Action
        expose :article

        params do
          required(:meeting_id).filled(:int?)
          required(:article_id).filled(:int?)
          required(:table).schema do
            required(:caption).filled(:str?)
            required(:tsv).filled(:str?)
          end
        end

        def initialize(table_repo: TableRepository.new,
                       article_repo: ArticleRepository.new,
                       admin_history_repo: AdminHistoryRepository.new,
                       authenticator: AdminAuthenticator.new)
          @table_repo = table_repo
          @article_repo = article_repo
          @admin_history_repo = admin_history_repo
          @authenticator = authenticator
          @notifications = {}
        end

        def call(params)
          @article = @article_repo.find_with_relations(params[:article_id], minimum: true)
          if params.valid?
            begin
              CSV.parse(params[:table][:tsv], col_sep: "\t")
              table = @table_repo.create(
                article_id: params[:article_id],
                caption: params[:table][:caption],
                csv: params[:table][:tsv]
              )
              @admin_history_repo.add(:table_create, gen_history_json(@article, table))
              flash[:notifications] = {success: {status: "Success:", message: "正常に表が追加されました"}}
              redirect_to routes.meeting_article_path(
                            meeting_id: params[:meeting_id],
                            id: params[:article_id])
            rescue CSV::MalformedCSVError
              @notifications = {error: {status: "Error:", message: "表データの形式が不正です. 正しく入力してください"}}
            end
          else
            @notifications = {error: {status: "Error:", message: "入力された項目に不備があります. もう一度確認してください"}}
          end
          self.status = 422
        end

        def gen_history_json(article, table)
          JSON.pretty_generate({
            action:"table_create",
            payload:{
              article: article.to_h.slice(:id, :title).merge({
                meeting: article.meeting.to_h.slice(:id, :date),
                author: {name: article.author.name}
              }),
              table: table.to_h
            }
          })
        end

        def notifications
          @notifications
        end
      end
    end
  end
end
