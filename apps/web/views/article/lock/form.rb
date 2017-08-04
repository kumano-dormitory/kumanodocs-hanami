module Web::Views::Article::Lock
  module Form
    def form
      form_for :author, routes.article_lock_path(article_id: params[:article_id]) do
        password_field :password

        submit '編集開始'
      end
    end
  end
end
