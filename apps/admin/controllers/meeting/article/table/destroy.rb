module Admin::Controllers::Meeting
  module Article
    module Table
      class Destroy
        include Admin::Action
        expose :table

        params do
          required(:id).filled(:int?)
          required(:table).schema do
            required(:confirm).filled(:bool?)
          end
        end

        def initialize(table_repo: TableRepository.new,
                       admin_history_repo: AdminHistoryRepository.new,
                       authenticator: AdminAuthenticator.new)
          @table_repo = table_repo
          @admin_history_repo = admin_history_repo
          @authenticator = authenticator
        end

        def call(params)
          @table = @table_repo.find_with_relations(params[:id])
          if params.valid?
            if params[:table][:confirm]
              @table_repo.delete(table.id)
              @admin_history_repo.add(:table_destroy, gen_history_json(@table))
              flash[:notifications] = {success: {status: "Success:", message: "正常に表が削除されました"}}
              redirect_to routes.meeting_article_path(
                            meeting_id: table.article.meeting_id,
                            id: table.article.id)
            end
          end
        end

        def gen_history_json(table)
          JSON.pretty_generate({
            action: "table_destroy",
            payload: {
              article: table.article.to_h.slice(:id, :title, :meeting_id).merge({author: {name: table.article.author.name}}),
              table: table.to_h.merge({article:{}})
            }
          })
        end
      end
    end
  end
end
