module Web::Views::Article
  module Form
    def form_create(meetings, categories)
      meetings_for_select = meetings.map { |meeting| [meeting.formatted_date, meeting.id] }.to_h
      categories_for_select = categories.map { |category| [category.name, category.id] }.to_h

      form_for :article,
               routes.articles_path,
               method: :post,
               class: "p-form p-form--stacked" do

        if !params.valid? && params.errors.dig(:article, :meeting_id)
          div class: "p-form__group p-form-validation is-error" do
            label  '日程', for: :meeting_id, class: "p-form__label u-align-text--right"
            div class: "p-form__control" do
              select :meeting_id, meetings_for_select, class: "p-form-validation__input", 'aria-invalid': "true"
              p class: "p-form-validation__message", role: "alert" do
                params.errors.dig(:article, :meeting_id).to_s
              end
            end
          end
        else
          div class: "p-form__group" do
            label  '日程', for: :meeting_id, class: "p-form__label u-align-text--right"
            div class: "p-form__control" do
              select :meeting_id, meetings_for_select
            end
          end
        end

        if !params.valid? && params.errors.dig(:article, :categories)
          div class: "p-form__group p-form-validation is-error u-vertically-center" do
            label '議案の種別', for: 'categories', class: "p-form__label u-align-text--right"
            div class: "p-form__control" do
              categories.each do |category|
                check_box :categories, name: 'article[categories][]', value: category.id, id: "category-#{category.id}", class: "p-form-validation__input"
                label category.name, for: "category-#{category.id}"
              end
              p class: "p-form-validation__message", role: "alert" do
                if params.errors.dig(:article, :categories).include?("size cannot be less than 1")
                  i class: "p-icon--error"
                  strong "少なくとも１つの種別を選択してください"
                else
                  "入力が不正です"
                end
              end
            end
          end
        else
          div class: "p-form__group u-vertically-center" do
            label '議案の種別', for: 'categories', class: "p-form__label u-align-text--right"
            div class: "p-form__control" do
              categories.each do |category|
                check_box :categories, name: 'article[categories][]', value: category.id, id: "category-#{category.id}"
                label category.name, for: "category-#{category.id}"
              end
            end
          end
        end

        if !params.valid? && params.errors.dig(:article, :title)
          div class: "p-form__group p-form-validation is-error" do
            label 'タイトル', for: :title, class: "p-form__label u-align-text--right"
            div class: "p-form__control" do
              text_field :title, class: "p-form-validation__input", 'aria-invalid': "true", required: ""
              p class: "p-form-validation__message", role: "alert" do
                if params.errors.dig(:article, :title).include?("must be filled")
                  strong "この項目は必須です"
                else
                  "入力が不正です　文字列を入力してください"
                end
              end
            end
          end
        else
          div class: "p-form__group" do
            label 'タイトル', for: :title, class: "p-form__label u-align-text--right", required: ""
            div class: "p-form__control" do
              text_field :title
            end
          end
        end

        fields_for :author do
          if !params.valid? && params.errors.dig(:article, :author, :name)
            div class: "p-form__group p-form-validation is-error" do
              label '文責者', for: :name, class: "p-form__label u-align-text--right"
              div class: "p-form__control" do
                text_field :name, class: "p-form-validation__input", 'aria-invalid': "true", required: ""
                p class: "p-form-validation__message", role: "alert" do
                  if params.errors.dig(:article, :author, :name).include?("must be filled")
                    strong "この項目は必須です"
                  else
                    "入力が不正です　文字列を入力してください"
                  end
                end
              end
            end
          else
            div class: "p-form__group" do
              label '文責者', for: :name, class: "p-form__label u-align-text--right"
              div class: "p-form__control" do
                text_field :name, required: ""
              end
            end
          end

          if !params.valid? && params.errors.dig(:article, :author, :password)
            div class: "p-form__group p-form-validation is-error" do
              label 'パスワード', for: :password, class: "p-form__label u-align-text--right"
              div class: "p-form__control" do
                password_field :password, class: "p-form-validation__input", 'aria-invalid': "true", required: ""
                p class: "p-form-validation__message", role: "alert" do
                  if params.errors.dig(:article, :author, :password).include?("must be filled")
                    strong "この項目は必須です"
                  else
                    "入力が不正です　文字列を入力してください"
                  end
                end
              end
            end
          else
            div class: "p-form__group" do
              label 'パスワード', for: :password, class: "p-form__label u-align-text--right"
              div class: "p-form__control" do
                password_field :password, required: ""
              end
            end
          end

          if !params.valid? && params.errors.dig(:article, :author, :password_confirmation)
            div class: "p-form__group p-form-validation is-error" do
              label 'パスワード（確認）', for: :password_confirmation, class: "p-form__label u-align-text--right"
              div class: "p-form__control" do
                password_field :password_confirmation, class: "p-form-validation__input", 'aria-invalid': "true", required: ""
                p class: "p-form-validation__message", role: "alert" do
                  if params.errors.dig(:article, :author, :password_confirmation).include?("must be filled")
                    strong "この項目は必須です"
                  elsif params.errors.dig(:article, :author, :password_confirmation).at(0)&.include?("must be equal to")
                    strong "入力されたパスワードが一致しませんでした. もう一度入力してください"
                  else
                    "入力が不正です　文字列を入力してください"
                  end
                end
              end
            end
          else
            div class: "p-form__group" do
              label 'パスワード（確認）', for: :password_confirmation, class: "p-form__label u-align-text--right"
              div class: "p-form__control" do
                password_field :password_confirmation, required: ""
              end
            end
          end
        end

        if !params.valid? && params.errors.dig(:article, :format)
          div class: "p-form__group p-form-validation is-error" do
            label '本文のフォーマット', for: :format, class: "p-form__label u-align-text--right"
            div class: "p-form__control" do
              label '', for: :format do
                text '議案をMarkdown形式で投稿する（必要がなければオフのままにしてください）'
                check_box :format, class: "p-switch p-form-validation__input", 'aria-invalid': "true"
                div '', class: "p-switch__slider"
              end
              p class: "p-form-validation__message", role: "alert" do
                if params.errors.dig(:article, :format).include?("must be filled")
                  strong "この項目は必須です"
                else
                  "入力が不正です"
                end
              end

            end
          end
        else
          div class: "p-form__group" do
            label '本文のフォーマット', for: :format, class: "p-form__label u-align-text--right"
            div class: "p-form__control" do
              label '', for: :format do
                text '議案をMarkdown形式で投稿する（必要がなければオフのままにしてください）'
                check_box :format, class: "p-switch"
                div '', class: "p-switch__slider"
              end
            end
          end
        end

        if !params.valid? && params.errors.dig(:article, :body)
          div class: "p-form__group p-form-validation is-error" do
            label '本文', for: :body, class: "p-form__label u-align-text--right"
            div class: "p-form__control" do
              div id: "markdown-tab", style: "display:none;" do
                nav class: "p-tabs" do
                  ul class: "p-tabs__list u-no-margin--bottom", role: "tablist" do
                    li class: "p-tabs__item", role: "presentation" do
                      a 'Markdown形式での入力', id: "tab-write", href: "#write", class: "p-tabs__link", tabindex: 0, role: "tab", 'aria-controls': "article-body", 'aria-selected': "true"
                    end
                    li class: "p-tabs__item", role: "presentation" do
                      a '本文のプレビュー', id: "tab-preview", href: "#preview", class: "p-tabs__link", tabindex: 0, role: "tab", 'aria-controls': "article-body"
                    end
                  end
                end
              end
              text_area :body, rows: 30, class: "p-form-validation__input", 'aria-invalid': "true", required: ""
              p class: "p-form-validation__message", role: "alert" do
                if params.errors.dig(:article, :body).include?("must be filled")
                  strong "この項目は必須です"
                else
                  "入力が不正です　文字列を入力してください"
                end
              end
              div '', id: "markdown-preview", class: "markdown"
            end
          end
        else
          div class: "p-form__group" do
            label '本文', for: :body, class: "p-form__label u-align-text--right"
            div class: "p-form__control" do
              div id: "markdown-tab", style: "display:none;" do
                nav class: "p-tabs" do
                  ul class: "p-tabs__list u-no-margin--bottom", role: "tablist" do
                    li class: "p-tabs__item", role: "presentation" do
                      a 'Markdown形式での入力', id: "tab-write", href: "#write", class: "p-tabs__link", tabindex: 0, role: "tab", 'aria-controls': "article-body", 'aria-selected': "true"
                    end
                    li class: "p-tabs__item", role: "presentation" do
                      a '本文のプレビュー', id: "tab-preview", href: "#preview", class: "p-tabs__link", tabindex: 0, role: "tab", 'aria-controls': "article-body"
                    end
                  end
                end
              end
              text_area :body, rows: 30, required: ""
              div '', id: "markdown-preview", class: "markdown"
            end
          end
        end

        if !params.valid? && params.errors.dig(:article, :vote_content)
          div class: "p-form__group p-form-validation is-error" do
            label '採決項目（議案の種別に「採決」が含まれていない場合には保存されません）', for: :vote_content, class: "p-form__label u-align-text--right"
            div class: "p-form__control" do
              text_area :vote_content, rows: 5, class: "p-form-validation__input", 'aria-invalid': "true"
              p class: "p-form-validation__message", role: "alert" do
                if params.errors.dig(:article, :vote_content).include?("must be filled")
                  strong "この項目は必須です"
                else
                  "入力が不正です　文字列を入力してください"
                end
              end
            end
          end
        else
          div class: "p-form__group" do
            label '採決項目（議案の種別に「採決」が含まれていない場合には保存されません）', for: :vote_content, class: "p-form__label u-align-text--right"
            div class: "p-form__control" do
              text_area :vote_content, rows: 5
            end
          end
        end

        submit '投稿', class: "p-button--positive u-float-right"
      end
    end

    def form_update(meetings, categories, hash = {})
      article = hash[:article]
      meetings_for_select = meetings.map { |meeting| [meeting.formatted_date, meeting.id] }.to_h
      categories_for_select = categories.map { |category| [category.name, category.id] }.to_h
      article_categories_selected = article&.article_categories&.map(&:category_id)

      values = if article.nil?
        {}
      else
        {
          article: article.to_h.merge(
            format: article.format == 1,
            vote_content: vote_content(article)
          )
        }
      end
      get_lock = hash[:confirm_update] ? true : false
      meeting_selected = [article&.meeting_id]

      form_for :article,
               routes.article_path(id: params[:id]),
               method: :patch,
               class: "p-form p-form--stacked",
               values: values do

        if get_lock
          div class: "p-form__group p-form-validation is-caution" do
            label 'パスワード', for: :password, class: "p-form__label"
            div class: "p-form__control" do
              password_field :password, class: "p-form-validation__input", required: ""
            end
          end
        end

        if !params.valid? && params.errors.dig(:article, :meeting_id)
          div class: "p-form__group p-form-validation is-error" do
            label  '日程', for: :meeting_id, class: "p-form__label"
            div class: "p-form__control" do
              select :meeting_id, meetings_for_select, options: { selected: meeting_selected },
                  class: "p-form-validation__input", 'aria-invalid': "true"
              p class: "p-form-validation__message", role: "alert" do
                params.errors.dig(:article, :meeting_id).to_s
              end
            end
          end
        else
          div class: "p-form__group" do
            label  '日程', for: :meeting_id, class: "p-form__label"
            div class: "p-form__control" do
              select :meeting_id, meetings_for_select, options: { selected: meeting_selected }
            end
          end
        end

        if !params.valid? && params.errors.dig(:article, :categories)
          div class: "p-form__group p-form-validation is-error u-vertically-center" do
            label '議案の種別', for: 'categories', class: "p-form__label"
            div class: "p-form__control" do
              categories.each do |category|
                if article_categories_selected&.include?(category.id)
                  check_box :categories, name: 'article[categories][]', value: category.id, id: "category-#{category.id}", checked: "checked", class: "p-form-validation__input"
                else
                  check_box :categories, name: 'article[categories][]', value: category.id, id: "category-#{category.id}", class: "p-form-validation__input"
                end
                label category.name, for: "category-#{category.id}"
              end
              p class: "p-form-validation__message", role: "alert" do
                if params.errors.dig(:article, :categories).include?("size cannot be less than 1")
                  i class: "p-icon--error"
                  strong "少なくとも１つの種別を選択してください"
                else
                  "入力が不正です"
                end
              end
            end
          end
        else
          div class: "p-form__group u-vertically-center" do
            label '議案の種別', for: 'categories', class: "p-form__label"
            div class: "p-form__control" do
              categories.each do |category|
                if article_categories_selected&.include?(category.id)
                  check_box :categories, name: 'article[categories][]', value: category.id, id: "category-#{category.id}", checked: "checked"
                else
                  check_box :categories, name: 'article[categories][]', value: category.id, id: "category-#{category.id}"
                end
                label category.name, for: "category-#{category.id}"
              end
            end
          end
        end

        if !params.valid? && params.errors.dig(:article, :title)
          div class: "p-form__group p-form-validation is-error" do
            label 'タイトル', for: :title, class: "p-form__label"
            div class: "p-form__control" do
              text_field :title, class: "p-form-validation__input", 'aria-invalid': "true", required: ""
              p class: "p-form-validation__message", role: "alert" do
                if params.errors.dig(:article, :title).include?("must be filled")
                  strong "この項目は必須です"
                else
                  "入力が不正です　文字列を入力してください"
                end
              end
            end
          end
        else
          div class: "p-form__group" do
            label 'タイトル', for: :title, class: "p-form__label"
            div class: "p-form__control" do
              text_field :title, required: ""
            end
          end
        end

        fields_for :author do
          if !params.valid? && params.errors.dig(:article, :author, :name)
            div class: "p-form__group p-form-validation is-error" do
              label '文責者', for: :name, class: "p-form__label"
              div class: "p-form__control" do
                text_field :name, class: "p-form-validation__input", 'aria-invalid': "true", required: ""
                p class: "p-form-validation__message", role: "alert" do
                  if params.errors.dig(:article, :author, :name).include?("must be filled")
                    strong "この項目は必須です"
                  else
                    "入力が不正です　文字列を入力してください"
                  end
                end
              end
            end
          else
            div class: "p-form__group" do
              label '文責者', for: :name, class: "p-form__label"
              div class: "p-form__control" do
                text_field :name, required: ""
              end
            end
          end
        end

        if !params.valid? && params.errors.dig(:article, :format)
          div class: "p-form__group p-form-validation is-error" do
            label '本文のフォーマット', for: :format, class: "p-form__label"
            div class: "p-form__control" do
              label '', for: :format do
                text '議案をMarkdown形式で投稿する（必要がなければオフのままにしてください）'
                check_box :format, class: "p-switch p-form-validation__input", 'aria-invalid': "true"
                div '', class: "p-switch__slider"
              end
              p class: "p-form-validation__message", role: "alert" do
                if params.errors.dig(:article, :format).include?("must be filled")
                  strong "この項目は必須です"
                else
                  "入力が不正です"
                end
              end

            end
          end
        else
          div class: "p-form__group" do
            label '本文のフォーマット', for: :format, class: "p-form__label"
            div class: "p-form__control" do
              label '', for: :format do
                text '議案をMarkdown形式で投稿する（必要がなければオフのままにしてください）'
                check_box :format, class: "p-switch"
                div '', class: "p-switch__slider"
              end
            end
          end
        end

        if !params.valid? && params.errors.dig(:article, :body)
          div class: "p-form__group p-form-validation is-error" do
            label '本文', for: :body, class: "p-form__label"
            div class: "p-form__control" do
              text_area :body, rows: 30, class: "p-form-validation__input", 'aria-invalid': "true", required: ""
              p class: "p-form-validation__message", role: "alert" do
                if params.errors.dig(:article, :body).include?("must be filled")
                  strong "この項目は必須です"
                else
                  "入力が不正です　文字列を入力してください"
                end
              end
            end
          end
        else
          div class: "p-form__group" do
            label '本文', for: :body, class: "p-form__label"
            div class: "p-form__control" do
              text_area :body, rows: 30, required: ""
            end
          end
        end

        if !params.valid? && params.errors.dig(:article, :vote_content)
          div class: "p-form__group p-form-validation is-error" do
            label '採決項目（議案の種別に「採決」が含まれていない場合には保存されません）', for: :vote_content, class: "p-form__label"
            div class: "p-form__control" do
              text_area :vote_content, rows: 5, class: "p-form-validation__input", 'aria-invalid': "true"
              p class: "p-form-validation__message", role: "alert" do
                if params.errors.dig(:article, :vote_content).include?("must be filled")
                  strong "この項目は必須です"
                else
                  "入力が不正です　文字列を入力してください"
                end
              end
            end
          end
        else
          div class: "p-form__group" do
            label '採決項目（議案の種別に「採決」が含まれていない場合には保存されません）', for: :vote_content, class: "p-form__label"
            div class: "p-form__control" do
              text_area :vote_content, rows: 5
            end
          end
        end

        div class: "p-form__group" do
          hidden_field :get_lock, value: get_lock
        end

        submit '保存', class: "p-button--positive u-float-right"
      end
    end

    def form_destroy(article)
      form_for :article, routes.article_path(id: article.id), method: :delete, class: 'delete_article' do
        div do
          label 'パスワード', for: :password
          password_field :password, required: ""
        end

        submit '削除', class: "p-button--negative"
      end
    end

    def form_search(keyword)
      form_for :search_article, routes.search_article_path, method: :get, class: "p-form p-form--inline", values: {keyword: keyword} do
        div(class: "p-form__group") do
          label '検索キーワード', for: :keywords, class: "p-form__label"
          text_field :keywords, class: "p-form__control"
        end
        submit '検索', class: "p-button--positive"
      end
    end
  end
end
