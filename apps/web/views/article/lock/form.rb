module Web::Views::Article::Lock
  module Form
    def form(for_table, table_id)
      if for_table
        form_for :author, routes.article_lock_for_table_path(article_id: params[:article_id],
                                                             table_id: table_id) do
          password_field :password

          submit '編集開始'
        end
      else
        form_for :author, routes.article_lock_path(article_id: params[:article_id]) do
          password_field :password

          submit '編集開始'
        end
      end
    end
  end
end
