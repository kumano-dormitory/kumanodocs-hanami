module Admin::Views::Meeting
  module Article
    module Table
      module Form
        def form_create(article)

          form_for :table,
                   routes.meeting_article_tables_path(meeting_id: article.meeting_id, article_id: article.id),
                   method: :post, class: "p-form" do

            div do
              label '題名', for: :caption
              text_field :caption, required: ""
            end

            div do
              label '表データ', for: :tsv
              text_area :tsv, rows: 20, required: ""
            end

            submit '表を追加', class: "p-button--positive"
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
                   class: "p-form",
                   values: values do

            div do
              label '題名', for: :caption
              text_field :caption, required: ""
            end

            div do
              label '表データ', for: :tsv
              text_area :tsv, required: ""
            end

            submit '表を更新', class: "p-button--positive"
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

            submit 'この表を削除', class: "p-button--negative"
          end
        end
      end
    end
  end
end
