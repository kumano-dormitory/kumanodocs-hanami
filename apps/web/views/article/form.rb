module Web::Views::Article
  module Form
    def form_create(meetings, categories, recent_articles, article_refs_selected = {})
      meetings_for_select = meetings.map { |meeting| [meeting.formatted_date, meeting.id] }.to_h
      categories_for_select = categories.map { |category| [category.name, category.id] }.to_h
      recent_articles_for_select = recent_articles.map do |article|
        ["#{article.meeting.date}のBL会議...#{article_formatted_title(article, number: false)}", article.id]
      end
      recent_articles_for_select.insert(0, ["過去の議案を選択してください. 複数選択ができます.", 0])
      same_refs_selected = article_refs_selected&.fetch(:same, false) || []
      other_refs_selected = article_refs_selected&.fetch(:other, false) || []

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

        div class: "p-form__group" do
          label '', for: :same_references, class: "p-form__label u-align-text--right" do
            text '過去のブロック会議の議案'
            br
            text '(過去のブロック会議に同じ議案を出している場合はその議案を選択してください)'
          end
          div class: "p-form__control" do
            div class: "p-search-box", style: 'margin-bottom: .8rem' do
              input type: 'search', name: 'query', class: 'p-search-box__input', id: 'same-refs-search-input',
                    placeholder: '議案の題名を入力して下の選択欄に表示される議案を絞ることができます'
              button type: 'reset', class: 'p-search-box__reset', id: 'same-refs-search-reset', alt: 'reset' do
                i class: 'p-icon--close'
              end
            end
            select :same_references, recent_articles_for_select, multiple: true, style: 'height: 20rem', options: {selected: 0}
            h4 '下に過去のブロック会議の議案として選択された議案が表示されます。選択を解除するには議案の『×』をクリックしてください。', class: "full-width"
            ul id: 'same-refs-selected', class: "p-list--divided" do
              if same_refs_selected.empty?
                text ''
              else
                same_refs_selected.each do |article_id|
                  li class: 'p-list__item is-ticked', style: 'padding-bottom: .25rem; padding-top: .25rem;' do
                    article = recent_articles.find{|a| a.id == article_id}
                    if article
                      text "#{article.meeting.date}のBL会議...#{article_formatted_title(article, number: false)}"
                      i class: 'p-icon--error', style: 'height:1.3rem;width:1.3rem;margin-left:1rem;'
                    end
                    input type: 'hidden', name: 'article[same_refs_selected][]', value: article_id
                  end
                end
              end
            end
          end
        end

        hr # horizontal line

        div class: "p-form__group" do
          label '', for: :other_references, class: "p-form__label u-align-text--right" do
            text 'その他の関連議案'
            br
            text '(関連議案として参照しておきたい議案がある場合は選択してください)'
          end
          div class: "p-form__control" do
            div class: "p-search-box", style: 'margin-bottom: .8rem' do
              input type: 'search', name: 'query', class: 'p-search-box__input', id: 'other-refs-search-input',
                    placeholder: '議案の題名を入力して下の選択欄に表示される議案を絞ることができます'
              button type: 'reset', class: 'p-search-box__reset', id: 'other-refs-search-reset', alt: 'reset' do
                i class: 'p-icon--close'
              end
            end
            select :other_references, recent_articles_for_select, multiple: true, style: 'height: 20rem', options: {selected: 0}
            h4 '下に関連議案として選択された議案が表示されます。選択を解除するには議案の『×』をクリックしてください。', class: "full-width"
            ul id: 'other-refs-selected', class: "p-list--divided" do
              if other_refs_selected.empty?
                text ''
              else
                other_refs_selected.each do |article_id|
                  li class: 'p-list__item is-ticked', style: 'padding-bottom: .25rem; padding-top: .25rem;' do
                    article = recent_articles.find{|a| a.id == article_id}
                    if article
                      text "#{article.meeting.date}のBL会議...#{article_formatted_title(article, number: false)}"
                      i class: 'p-icon--error', style: 'height:1.3rem;width:1.3rem;margin-left:1rem;'
                    end
                    input type: 'hidden', name: 'article[other_refs_selected][]', value: article_id
                  end
                end
              end
            end
          end
        end

        hr # horizontal line

        div class: "p-form__group" do
          div '', class: "p-form__label"
          div class: "p-form__control" do
            p '※以下のどちらかを選択してください.「議案のみを投稿」した場合でも、議案の編集ページから表を追加することができます.'
            submit '議案のみを投稿する', class: "p-button--positive", name: "action", value: "post_article"
            submit '議案を投稿して、投稿した議案に表を追加する', class: "p-button--positive", name: "action", value: "post_article_with_table"
          end
        end
      end
    end

    def form_update(meetings, categories, recent_articles, article_refs_selected = {}, hash = {})
      article = hash[:article]
      meetings_for_select = meetings.map { |meeting| [meeting.formatted_date, meeting.id] }.to_h
      categories_for_select = categories.map { |category| [category.name, category.id] }.to_h
      article_categories_selected = article&.article_categories&.map(&:category_id)
      recent_articles_for_select = recent_articles.map do |article|
        ["#{article.meeting.date}のBL会議...#{article_formatted_title(article, number: false)}", article.id]
      end
      recent_articles_for_select.insert(0, ["過去の議案を選択してください. 複数選択ができます.", 0])
      same_refs_selected = article_refs_selected&.fetch(:same, false) || []
      other_refs_selected = article_refs_selected&.fetch(:other, false) || []

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
            label '本文', for: :body, class: "p-form__label"
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
          label '', for: :same_references, class: "p-form__label u-align-text--right" do
            text '過去のブロック会議の議案'
            br
            text '(過去のブロック会議に同じ議案を出している場合はその議案を選択してください)'
          end
          div class: "p-form__control" do
            div class: "p-search-box", style: 'margin-bottom: .8rem' do
              input type: 'search', name: 'query', class: 'p-search-box__input', id: 'same-refs-search-input',
                    placeholder: '議案の題名を入力して下の選択欄に表示される議案を絞ることができます'
              button type: 'reset', class: 'p-search-box__reset', id: 'same-refs-search-reset', alt: 'reset' do
                i class: 'p-icon--close'
              end
            end
            select :same_references, recent_articles_for_select, multiple: true, style: 'height: 20rem', options: {selected: 0}
            h4 '下に過去のブロック会議の議案として選択された議案が表示されます。選択を解除するには議案の『×』をクリックしてください。', class: "full-width"
            ul id: 'same-refs-selected', class: "p-list--divided" do
              if same_refs_selected.empty?
                text ''
              else
                same_refs_selected.each do |article_id|
                  li class: 'p-list__item is-ticked', style: 'padding-bottom: .25rem; padding-top: .25rem;' do
                    article = recent_articles.find{|a| a.id == article_id}
                    if article
                      text "#{article.meeting.date}のBL会議...#{article_formatted_title(article, number: false)}"
                      i class: 'p-icon--error', style: 'height:1.3rem;width:1.3rem;margin-left:1rem;'
                    end
                    input type: 'hidden', name: 'article[same_refs_selected][]', value: article_id
                  end
                end
              end
            end
          end
        end

        hr # horizontal line

        div class: "p-form__group" do
          label '', for: :other_references, class: "p-form__label u-align-text--right" do
            text 'その他の関連議案'
            br
            text '(参考議案として参照しておきたい議案がある場合は選択してください)'
          end
          div class: "p-form__control" do
            div class: "p-search-box", style: 'margin-bottom: .8rem' do
              input type: 'search', name: 'query', class: 'p-search-box__input', id: 'other-refs-search-input',
                    placeholder: '議案の題名を入力して下の選択欄に表示される議案を絞ることができます'
              button type: 'reset', class: 'p-search-box__reset', id: 'other-refs-search-reset', alt: 'reset' do
                i class: 'p-icon--close'
              end
            end
            select :other_references, recent_articles_for_select, multiple: true, style: 'height: 20rem', options: {selected: 0}
            h4 '下に関連議案として選択された議案が表示されます。選択を解除するには議案の『×』をクリックしてください。', class: "full-width"
            ul id: 'other-refs-selected', class: "p-list--divided" do
              if other_refs_selected.empty?
                text ''
              else
                other_refs_selected.each do |article_id|
                  li class: 'p-list__item is-ticked', style: 'padding-bottom: .25rem; padding-top: .25rem;' do
                    article = recent_articles.find{|a| a.id == article_id}
                    if article
                      text "#{article.meeting.date}のBL会議...#{article_formatted_title(article, number: false)}"
                      i class: 'p-icon--error', style: 'height:1.3rem;width:1.3rem;margin-left:1rem;'
                    end
                    input type: 'hidden', name: 'article[other_refs_selected][]', value: article_id
                  end
                end
              end
            end
          end
        end

        hr # horizontal line

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

    def form_select_article(recent_meetings_with_articles)
      meetings_for_select = recent_meetings_with_articles.map do |meeting, _|
        ["#{meeting.formatted_date}のブロック会議", meeting.date]
      end
      meetings_for_select.insert(0, ['ブロック会議を選択してください', 0])
      articles_for_select = recent_meetings_with_articles.map do |meeting, articles|
        articles.map do |article|
          ["#{meeting.date}のBL会議...#{article_formatted_title(article, number: false)}", article.id]
        end
      end
      articles_for_select.reduce(:concat)
      articles_for_select = articles_for_select[0].insert(0, ['議案を選択してください', 0])

      form_for :diff, routes.diff_article_path, method: :get, class: "p-form" do
        label '議案を選んでください（旧版）', class: "p-heading--four"
        select :old_meeting, meetings_for_select
        select :old_article, articles_for_select

        label '議案を選んでください（新版）', class: "p-heading--four"
        select :new_meeting, meetings_for_select
        select :new_article, articles_for_select

        submit '議案を比較'
      end
    end
  end
end
