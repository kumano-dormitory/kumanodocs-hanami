module Web::Views::Docs
  module Form
    def form_create(user)
      user_select = {user.name => user.id}
      type_select = {'テキスト形式（markdown)' => 0, 'PDFファイル' => 1, '外部サイトへのリンク' => 2}

      form_for :document, routes.documents_path, method: :post, class: "p-form p-form--stacked", enctype: 'multipart/form-data' do
        div class: "p-form__group row" do
          div class: "col-2" do
            label  '題名', for: :meeting_id, class: "p-form__label u-align-text--right"
          end
          div class: "col-10" do
            div class: "p-form__control" do
              text_field :title, required: ""
            end
          end
        end
        div class: "p-form__group row" do
          div class: "col-2" do
            label  '文責', for: :user_id, class: "p-form__label u-align-text--right"
          end
          div class: "col-10" do
            div class: "p-form__control" do
              select :user_id, user_select, required: ""
            end
          end
        end
        div class: "p-form__group row" do
          div class: "col-2" do
            label  '資料のフォーマット', for: :type, class: "p-form__label u-align-text--right"
          end
          div class: "col-10" do
            div class: "p-form__control" do
              select :type, type_select, required: ""
            end
          end
        end
        div class: "p-form__group row", id: "document-body-group" do
          div class: "col-2" do
            label  '本文', for: :body, class: "p-form__label u-align-text--right"
          end
          div class: "col-10" do
            div class: "p-form__control" do
              text_area :body, rows: 30
            end
          end
        end
        div class: "p-form__group row", id: "document-data-group" do
          div class: "col-2" do
            label  'PDFファイル', for: :data, class: "p-form__label u-align-text--right"
          end
          div class: "col-10" do
            div class: "p-form__control" do
              file_field :data
            end
          end
        end
        div class: "p-form__group row", id: "document-url-group" do
          div class: "col-2" do
            label  'URLリンク', for: :url, class: "p-form__label u-align-text--right"
          end
          div class: "col-10" do
            div class: "p-form__control" do
              url_field :url
            end
          end
        end
        submit '新規作成', class: "p-button--positive u-float-right"
      end
    end

    def form_update(document)
      user_select = {document.user.name => document.user.id}
      type_select = {'テキスト形式（markdown)' => 0, 'PDFファイル' => 1, '外部サイトへのリンク' => 2}
      values = {document: document}

      form_for :document,
               routes.document_path(id: document.id),
               method: :patch,
               class: "p-form p-form--stacked",
               values: values do
        div class: "p-form__group row" do
          div class: "col-2" do
            label  '題名', for: :meeting_id, class: "p-form__label u-align-text--right"
          end
          div class: "col-10" do
            div class: "p-form__control" do
              text_field :title, required: ""
            end
          end
        end
        div class: "p-form__group row" do
          div class: "col-2" do
            label  '文責', for: :user_id, class: "p-form__label u-align-text--right"
          end
          div class: "col-10" do
            div class: "p-form__control" do
              select :user_id, user_select, required: ""
            end
          end
        end
        div class: "p-form__group row" do
          div class: "col-2" do
            label  '資料のフォーマット', for: :type, class: "p-form__label u-align-text--right"
          end
          div class: "col-10" do
            div class: "p-form__control" do
              select :type, type_select, required: ""
            end
          end
        end
        div class: "p-form__group row", id: "document-body-group" do
          div class: "col-2" do
            label  '本文', for: :body, class: "p-form__label u-align-text--right"
          end
          div class: "col-10" do
            div class: "p-form__control" do
              text_area :body, rows: 30
            end
          end
        end
        div class: "p-form__group row", id: "document-data-group" do
          div class: "col-2" do
            label  'PDFファイル', for: :data, class: "p-form__label u-align-text--right"
          end
          div class: "col-10" do
            div class: "p-form__control" do
              file_field :data
            end
          end
        end
        div class: "p-form__group row", id: "document-url-group" do
          div class: "col-2" do
            label  'URLリンク', for: :url, class: "p-form__label u-align-text--right"
          end
          div class: "col-10" do
            div class: "p-form__control" do
              url_field :url
            end
          end
        end
        submit '保存', class: "p-button--positive u-float-right"
      end
    end
  end
end
