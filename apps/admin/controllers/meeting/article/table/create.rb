require 'csv'

module Admin::Controllers::Meeting
  module Article
    module Table
      class Create
        include Admin::Action
        expose :article

        params do
          required(:article_id).filled(:int?)
          required(:table).schema do
            required(:caption).filled(:str?)
            required(:tsv).filled(:str?)
          end
        end

        def initialize(table_repo: TableRepository.new,
                       article_repo: ArticleRepository.new)
          @table_repo = table_repo
          @article_repo = article_repo
        end

        def call(params)
          if params.valid?
            begin
              CSV.parse(params[:table][:tsv], col_sep: "\t")
              @table_repo.create(
                article_id: params[:article_id],
                caption: params[:table][:caption],
                csv: params[:table][:tsv]
              )
              redirect_to routes.meeting_article_path(
                            meeting_id: params[:meeting_id],
                            id: params[:article_id])
            rescue CSV::MalformedCSVError
            end
          end
          @article = @article_repo.find(params[:article_id])
          self.status = 422
        end
      end
    end
  end
end
