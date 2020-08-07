module Web::Views::Table
  module Form
    def form_create(articles, article_id=nil)
      articles_for_select = articles.map { |article| [article.title, article.id] }.to_h

      form_for :table,
               routes.tables_path,
               method: :post, class: "p-form p-form--stacked" do

        if !params.valid? && params.errors.dig(:table, :article_id)
          div class: "p-form__group row p-form-validation is-error" do
            div class: "col-2" do
              label '議案', for: :article_id
            end
            div class: "col-10" do
              select :article_id, articles_for_select, class: "p-form-validation__input"
              p class: "p-form-validation__message" do
                "入力が不正です 一つを選択してください"
              end
            end
          end
        else
          div class: "p-form__group row" do
            div class: "col-2" do
              label '議案', for: :article_id
            end
            div class: "col-10" do
              select :article_id, articles_for_select, options: {selected: article_id}
            end
          end
        end

        if !params.valid? && params.errors.dig(:table, :article_passwd)
          div class: "p-form__group row p-form-validation is-error" do
            div class: "col-2" do
              label '議案のパスワード', for: :article_passwd
            end
            div class: "col-10" do
              password_field :article_passwd, class: "p-form-validation__input", autocomplete: "new-password"
              p class: "p-form-validation__message" do
                if params.errors.dig(:table, :article_passwd).include?("must be filled")
                  strong "この項目は必須です"
                else
                  "入力が不正です. 文字列を入力してください"
                end
              end
            end
          end
        else
          div class: "p-form__group row" do
            div class: "col-2" do
              label '議案のパスワード', for: :article_passwd
            end
            div class: "col-10" do
              password_field :article_passwd, autocomplete: "new-password"
            end
          end
        end

        if !params.valid? && params.errors.dig(:table, :caption)
          div class: "p-form__group row p-form-validation is-error" do
            div class: "col-2" do
              label '題名', for: :caption
            end
            div class: "col-10" do
              text_field :caption, class: "p-form-validation__input"
              p class: "p-form-validation__message" do
                if params.errors.dig(:table, :caption).include?("must be filled")
                  strong "この項目は必須です"
                else
                  "入力が不正です. 文字列を入力してください"
                end
              end
            end
          end
        else
          div class: "p-form__group row" do
            div class: "col-2" do
              label '題名', for: :caption
            end
            div class: "col-10" do
              text_field :caption
            end
          end
        end

        if !params.valid? && params.errors.dig(:table, :tsv)
          div class: "p-form__group row p-form-validation is-error" do
            div class: "col-2" do
              label '表データ', for: :tsv
            end
            div class: "col-10" do
              text_area :tsv, rows: 30, class: "p-form-validation__input"
              p class: "p-form-validation__message" do
                if params.errors.dig(:table, :tsv).include?("must be filled")
                  strong "この項目は必須です"
                else
                  "入力が不正です. 文字列を入力してください"
                end
              end
            end
          end
        else
          div class: "p-form__group row" do
            div class: "col-2" do
              label '表データ', for: :tsv
            end
            div class: "col-10" do
              text_area :tsv, rows: 30
            end
          end
        end

        div class: "row" do
          div '', class: "col-2"
          div class: "col-4" do
            submit '表を追加', class: "p-button--positive"
          end
        end
      end
    end

    def form_update(table, hash = {})
      values = {table: {caption: table.caption, tsv: table.csv }}
      get_lock = hash[:confirm_update] ? true : false

      form_for :table,
               routes.table_path(id: table.id),
               method: :patch, class: "p-form p-form--stacked",
               values: values do

        if get_lock
          div class: "p-form__group row p-form-validation is-caution" do
            div class: "col-2" do
              label '議案のパスワード', for: :article_passwd
            end
            div class: "col-10" do
              password_field :article_passwd, class: "p-form-validation__input", autocomplete: "new-password"
            end
          end
        end

        if !params.valid? && params.errors.dig(:table, :caption)
          div class: "p-form__group row p-form-validation is-error" do
            div class: "col-2" do
              label '題名', for: :caption
            end
            div class: "col-10" do
              text_field :caption, class: "p-form-validation__input"
              p class: "p-form-validation__message" do
                if params.errors.dig(:table, :caption).include?("must be filled")
                  strong "この項目は必須です"
                else
                  "入力が不正です. 文字列を入力してください"
                end
              end
            end
          end
        else
          div class: "p-form__group row" do
            div class: "col-2" do
              label '題名', for: :caption
            end
            div class: "col-10" do
              text_field :caption
            end
          end
        end

        if !params.valid? && params.errors.dig(:table, :tsv)
          div class: "p-form__group row p-form-validation is-error" do
            div class: "col-2" do
              label '表データ', for: :tsv
            end
            div class: "col-10" do
              text_area :tsv, rows: 30, class: "p-form-validation__input"
              p class: "p-form-validation__message" do
                if params.errors.dig(:table, :tsv).include?("must be filled")
                  strong "この項目は必須です"
                else
                  "入力が不正です. 文字列を入力してください"
                end
              end
            end
          end
        else
          div class: "p-form__group row" do
            div class: "col-2" do
              label '表データ', for: :tsv
            end
            div class: "col-10" do
              text_area :tsv, rows: 30
            end
          end
        end

        div do
          hidden_field :get_lock, value: get_lock
        end

        div class: "row" do
          div '', class: "col-2"
          div class: "col-10" do
            submit '表を更新', class: "p-button--positive"
          end
        end
      end
    end

    def form_destroy(table)
      form_for :table,
               routes.table_path(id: table.id),
               method: :delete,
               class: "p-form p-form--inline" do

        div class: "p-form__group" do
          password_field :article_passwd, autocomplete: "new-password"
        end

        div do
          hidden_field :confirm, value: true
        end

        submit 'この表を削除', class: "p-button--negative"
      end
    end
  end
end
