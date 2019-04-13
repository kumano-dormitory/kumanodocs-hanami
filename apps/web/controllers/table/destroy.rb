module Web::Controllers::Table
  class Destroy
    include Web::Action
    expose :table

    params do
      required(:id).filled(:int?)
      optional(:table).schema do
        required(:article_passwd).filled(:str?)
        required(:confirm).filled(:bool?)
      end
    end

    def initialize(table_repo: TableRepository.new)
      @table_repo = table_repo
    end

    def call(params)
      if params.valid?
        @table = @table_repo.find_with_relations(params[:id])

        if !params.dig(:table, :confirm).nil? && params.dig(:table, :confirm)
          @table_repo.delete(params[:id])
          redirect_to routes.article_path(id: table.article_id)
        else
        end
      end
    end
  end
end
