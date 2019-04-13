module Admin::Views::Meeting
  module Article
    module Table
      module Form
        def form_create(article)

          form_for :table,
                   routes.meeting_article_tables_path(meeting_id: article.meeting_id, article_id: article.id),
                   method: :post do

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

        def form_update(table)
          values = {table: {caption: table.caption, tsv: table.csv }}

          form_for :table,
                   routes.meeting_article_table_path(
                      meeting_id: table.article.meeting_id,
                      article_id: table.article.id,
                      id: table.id
                   ),
                   method: :patch,
                   values: values do

            div do
              label '題名', for: :caption
              text_field :caption
            end

            div do
              label '表データ', for: :tsv
              text_area :tsv
            end

            submit '表を更新'
          end
        end

        def form_destroy(table)
          form_for :table,
                   routes.meeting_article_table_path(
                     meeting_id: table.article.meeting_id,
                     article_id: table.article.id,
                     id: table.id
                   ),
                   method: :delete do

            div do
              hidden_field :confirm, value: true
            end

            submit 'この表を削除'
          end
        end
      end
    end
  end
end
