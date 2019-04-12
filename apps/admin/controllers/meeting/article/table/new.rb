module Admin::Controllers::Meeting
  module Article
    module Table
      class New
        include Admin::Action
        expose :article

        def initialize(table_repo: TableRepository.new,
                       article_repo: ArticleRepository.new)
          @table_repo = table_repo
          @article_repo = article_repo
        end

        def call(params)
          @article = @article_repo.find(params[:article_id])
        end
      end
    end
  end
end
