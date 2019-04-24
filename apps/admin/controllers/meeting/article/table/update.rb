require 'csv'

module Admin::Controllers::Meeting
  module Article
    module Table
      class Update
        include Admin::Action
        expose :table

        params do
          required(:table).schema do
            required(:caption).filled(:str?)
            required(:tsv).filled(:str?)
          end
        end

        def initialize(table_repo: TableRepository.new)
          @table_repo = table_repo
          @notifications = {}
        end

        def call(params)
          @table = @table_repo.find_with_relations(params[:id])
          if params.valid?
            begin
              CSV.parse(params[:table][:tsv], col_sep: "\t")
              @table_repo.update(
                params[:id],
                caption: params[:table][:caption],
                csv: params[:table][:tsv]
              )
              flash[:notifications] = {success: {status: "Success:", message: "正常に表が編集されました"}}
              redirect_to routes.meeting_article_path(
                            meeting_id: table.article.meeting_id,
                            id: table.article.id)
            rescue CSV::MalformedCSVError
              @notifications = {error: {status: "Error:", message: "表データの形式が不正です. 正しく入力してください"}}
            end
          else
            @notifications = {error: {status: "Error:", message: "入力された項目に不備があります. もう一度確認してください"}}
          end
          self.status = 422
        end

        def notifications
          @notifications
        end
      end
    end
  end
end
