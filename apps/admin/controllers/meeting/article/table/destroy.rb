module Admin::Controllers::Meeting
  module Article
    module Table
      class Destroy
        include Admin::Action
        expose :table

        params do
          required(:table).schema do
            required(:confirm).filled(:bool?)
          end
        end

        def initialize(table_repo: TableRepository.new,
                       admin_history_repo: AdminHistoryRepository.new)
          @table_repo = table_repo
          @admin_history_repo = admin_history_repo
        end

        def call(params)
          @table = @table_repo.find_with_relations(params[:id])
          if params.valid?
            if params[:table][:confirm]
              @table_repo.delete(table.id)
              @admin_history_repo.add(:table_destroy, JSON.pretty_generate({action:"table_destroy", payload:{table: @table.to_h.merge({article:{}})}}))
              flash[:notifications] = {success: {status: "Success:", message: "正常に表が削除されました"}}
              redirect_to routes.meeting_article_path(
                            meeting_id: table.article.meeting_id,
                            id: table.article.id)
            end
          end
        end
      end
    end
  end
end
