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

        def initialize(table_repo: TableRepository.new)
          @table_repo = table_repo
        end

        def call(params)
          @table = @table_repo.find_with_relations(params[:id])
          if params.valid?
            if params[:table][:confirm]
              @table_repo.delete(table.id)
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
