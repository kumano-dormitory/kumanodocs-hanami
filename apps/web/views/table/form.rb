module Web::Views::Table
  module Form
    def form_create(articles)
      articles_for_select = articles.map { |article| [article.title, article.id] }.to_h

      form_for :table,
               routes.tables_path,
               method: :post do

        div do
          label '議案', for: :article_id
          select :article_id, articles_for_select
        end

        div do
          label '議案のパスワード', for: :article_passwd
          password_field :article_passwd
        end

        div do
          label '題名', for: :caption
          text_field :caption
        end

        div do
          label '表データ', for: :tsv
          text_area :tsv
        end

        submit '表を追加'
      end
    end

    def form_update(table, hash = {})
      values = {table: {caption: table.caption, tsv: table.csv }}
      get_lock = hash[:confirm_update] ? true : false

      form_for :table,
               routes.table_path(id: table.id),
               method: :patch,
               values: values do

       if get_lock
         div do
           label 'パスワード', for: :article_passwd
           password_field :article_passwd
         end
       end

        div do
          label '題名', for: :caption
          text_field :caption
        end

        div do
          label '表データ', for: :tsv
          text_area :tsv
        end

        div do
          hidden_field :get_lock, value: get_lock
        end

        submit '表を更新'
      end
    end

    def form_destroy(table)
      form_for :table,
               routes.table_path(id: table.id),
               method: :delete do

        div do
          label '議案のパスワード', for: :article_passwd
          password_field :article_passwd
        end

        div do
          hidden_field :confirm, value: true
        end

        submit 'この表を削除'
      end
    end
  end
end
