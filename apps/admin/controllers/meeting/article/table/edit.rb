module Admin::Controllers::Meeting
  module Article
    module Table
      class Edit
        include Admin::Action
        expose :table

        def initialize(table_repo: TableRepository.new,
                       authenticator: AdminAuthenticator.new)
          @table_repo = table_repo
          @authenticator = authenticator
        end

        def call(params)
          @table = @table_repo.find_with_relations(params[:id])
        end
      end
    end
  end
end
