module Admin::Views::Docs
  module Form
    def form_create(users)
      user_select = users.map{|user| [user.name, user.id]}
      type_select = {'テキスト形式（markdown)' => 0, 'PDFファイル' => 1, '外部サイトへのリンク' => 2}

      form_for :document, routes.docs_path, method: :post, class: "p-form p-form--stacked", enctype: 'multipart/form-data' do
        div class: "p-form__group" do
          label  '題名', for: :meeting_id, class: "p-form__label u-align-text--right"
          div class: "p-form__control" do
            text_field :title, required: ""
          end
        end
        div class: "p-form__group" do
          label  '文責', for: :user_id, class: "p-form__label u-align-text--right"
          div class: "p-form__control" do
            select :user_id, user_select, required: ""
          end
        end
        div class: "p-form__group" do
          label  '資料のフォーマット', for: :type, class: "p-form__label u-align-text--right"
          div class: "p-form__control" do
            select :type, type_select, required: ""
          end
        end
        div class: "p-form__group", id: "document-body-group" do
          label  '本文', for: :body, class: "p-form__label u-align-text--right"
          div class: "p-form__control" do
            text_area :body, rows: 30
          end
        end
        div class: "p-form__group", id: "document-data-group" do
          label  'PDFファイル', for: :data, class: "p-form__label u-align-text--right"
          div class: "p-form__control" do
            file_field :data
          end
        end
        div class: "p-form__group", id: "document-url-group" do
          label  'URLリンク', for: :url, class: "p-form__label u-align-text--right"
          div class: "p-form__control" do
            url_field :url
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
               routes.doc_path(id: document.id),
               method: :patch,
               class: "p-form p-form--stacked",
               values: values do
        div class: "p-form__group" do
          label  '題名', for: :meeting_id, class: "p-form__label u-align-text--right"
          div class: "p-form__control" do
            text_field :title, required: ""
          end
        end
        div class: "p-form__group" do
          label  '文責', for: :user_id, class: "p-form__label u-align-text--right"
          div class: "p-form__control" do
            select :user_id, user_select, required: ""
          end
        end
        div class: "p-form__group" do
          label  '資料のフォーマット', for: :type, class: "p-form__label u-align-text--right"
          div class: "p-form__control" do
            select :type, type_select, required: ""
          end
        end
        div class: "p-form__group", id: "document-body-group" do
          label  '本文', for: :body, class: "p-form__label u-align-text--right"
          div class: "p-form__control" do
            text_area :body, rows: 30
          end
        end
        div class: "p-form__group", id: "document-data-group" do
          label  'PDFファイル', for: :data, class: "p-form__label u-align-text--right"
          div class: "p-form__control" do
            file_field :data
          end
        end
        div class: "p-form__group", id: "document-url-group" do
          label  'URLリンク', for: :url, class: "p-form__label u-align-text--right"
          div class: "p-form__control" do
            url_field :url
          end
        end
        submit '保存', class: "p-button--positive u-float-right"
      end
    end

    def form_order
      form_for :documents,
               routes.order_docs_path,
               id: "form_for_doc_order",
               method: :patch, class: "p-form" do

        button '保存', id: "post_docs_order_btn", class: "p-button--positive"
      end
    end
  end
end
