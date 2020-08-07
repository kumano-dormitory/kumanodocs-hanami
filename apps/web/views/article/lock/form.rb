module Web::Views::Article::Lock
  module Form
    def form(for_table, table_id)
      if for_table
        form_for :author,
                 routes.article_lock_for_table_path(article_id: params[:article_id], table_id: table_id),
                 class: "p-form p-form--inline" do
          div class: "p-form__group" do
            div class: "p-form__control" do
              password_field :password, placeholder: "Password", autocomplete: "new-password"
            end
          end
          submit '編集開始', class: "p-button--neutral"
        end
      else
        form_for :author, routes.article_lock_path(article_id: params[:article_id]), class: "p-form p-form--inline" do
          div class: "p-form__group" do
            div class: "p-form__control" do
              password_field :password, placeholder: "Password", autocomplete: "new-password"
            end
          end
          submit '編集開始', class: "p-button--neutral"
        end
      end
    end
  end
end
