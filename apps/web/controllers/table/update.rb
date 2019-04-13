module Web::Controllers::Table
  class Update
    include Web::Action
    expose :table, :confirm_update

    params do
      required(:table).schema do
        required(:get_lock).filled(:bool?)
        optional(:article_passwd).filled(:str?)
        required(:caption).filled(:str?)
        required(:tsv).filled(:str?)
      end
    end

    def initialize(table_repo: TableRepository.new,
                   author_repo: AuthorRepository.new)
      @table_repo = table_repo
      @author_repo = author_repo
    end

    def call(params)
      if params.valid?
        article = @table_repo.find_with_relations(params[:id]).article
        if article.author.lock_key == cookies[:article_lock_key] \
          || (params[:table][:get_lock] && article.author.authenticate(params[:table][:article_passwd]))

          table_params = {
            caption: params[:table][:caption],
            csv: params[:table][:tsv]
          }
          @table_repo.update(params[:id], table_params)
          @author_repo.release_lock(article.author_id)
          redirect_to routes.article_path(id: article.id)
        else
          @confirm_update = true
        end
      else
        self.status = 422
      end
      @table = @table_repo.find_with_relations(params[:id])
    end
  end
end
