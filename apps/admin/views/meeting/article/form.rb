module Admin::Views::Meeting
  module Article
    module Form
      def form_for_create(meeting, categories, recent_articles, article_refs_selected = {})
        meeting_for_select = { meeting.date => meeting.id }
        recent_articles_for_select = recent_articles.map do |article|
          ["#{article.meeting.date}のBL会議...#{article_formatted_title(article, number: false)}", article.id]
        end
        recent_articles_for_select.insert(0,["過去の議案を選択してください. 複数選択ができます.", 0])
        same_refs_selected = article_refs_selected[:same] || []
        other_refs_selected = article_refs_selected[:other] || []

        form_for :article,
                 routes.meeting_articles_path(meeting_id: params[:meeting_id]),
                 method: :post, class: "p-form p-form--stacked" do

          if !params.valid? && params.errors.dig(:article, :meeting_id)
            div class: "p-form__group p-form-validation is-error" do
              label  '日程', for: :meeting_id, class: "p-form__label u-align-text--right"
              div class: "p-form__control" do
                select :meeting_id, meeting_for_select, class: "p-form-validation__input", 'aria-invalid': "true"
                p class: "p-form-validation__message", role: "alert" do
                  params.errors.dig(:article, :meeting_id).to_s
                end
              end
            end
          else
            div class: "p-form__group" do
              label  '日程', for: :meeting_id, class: "p-form__label u-align-text--right"
              div class: "p-form__control" do
                select :meeting_id, meeting_for_select
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

          if !params.valid? && params.errors.dig(:article, :checked)
            div class: "p-form__group p-form-validation is-error u-vertically-center" do
              label '資料委員会のチェック済みか(スイッチがオンの場合は通常議案、オフの場合は追加議案)', for: :checked, class: "p-form__label u-align-text--right"
              div class: "p-form__control" do
                label '', for: :checked do
                  check_box :checked, class: "p-switch", checked: true
                  div '', class: "p-switch__slider"
                end
                p class: "p-form-validation__message", role: "alert" do
                  if params.errors.dig(:article, :checked).include?("must be filled")
                    strong "この項目は必須です"
                  else
                    "入力が不正です"
                  end
                end
              end
            end
          else
            div class: "p-form__group u-vertically-center" do
              label '資料委員会のチェック済みか(スイッチがオンの場合は通常議案、オフの場合は追加議案)', for: :checked, class: "p-form__label u-align-text--right"
              div class: "p-form__control" do
                label '', for: :checked do
                  check_box :checked, class: "p-switch", checked: true
                  div '', class: "p-switch__slider"
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
              label 'タイトル', for: :title, class: "p-form__label u-align-text--right"
              div class: "p-form__control" do
                text_field :title, required: ""
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
              label '本文', for: :body, class: "p-form__label u-align-text--right"
              div class: "p-form__control" do
                text_area :body, rows: 30, required: ""
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
              h4 '下に選択された議案が表示されます。選択を解除するには議案の『×』をクリックしてください。', class: "full-width"
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
              text 'その他の参考議案'
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
              h4 '下に選択された議案が表示されます。選択を解除するには議案の『×』をクリックしてください。', class: "full-width"
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

          submit '投稿', class: "p-button--positive u-float-right"
        end
      end

      def form_for_update(meetings, categories, recent_articles, article_refs_selected = {}, article = nil)
        meetings_for_select = meetings.map { |meeting| [meeting.date, meeting.id] }.to_h
        categories_for_select = categories.map { |category| [category.name, category.id] }.to_h
        article_categories_selected = article&.article_categories&.map(&:category_id)
        meeting_selected = [article&.meeting_id]
        recent_articles_for_select = recent_articles.reject{|a| a.id == article&.id}.map do |article|
          ["#{article.meeting.date}のBL会議...#{article_formatted_title(article, number: false)}", article.id]
        end
        recent_articles_for_select.insert(0,["過去の議案を選択してください. 複数選択ができます.", 0])
        same_refs_selected = article_refs_selected&.fetch(:same, false) || []
        other_refs_selected = article_refs_selected&.fetch(:other, false) || []

        values = article.nil? ? {} : {
          article: article.to_h.merge(
            format: article.format == 1,
            vote_content: vote_content(article)
          )
        }

        form_for :article,
                 routes.meeting_article_path(meeting_id: params[:meeting_id], id: params[:id]),
                 method: :patch,
                 values: values,
                 class: "p-form p-form--stacked" do

          if !params.valid? && params.errors.dig(:article, :meeting_id)
            div class: "p-form__group p-form-validation is-error" do
              label  '日程', for: :meeting_id, class: "p-form__label u-align-text--right"
              div class: "p-form__control" do
                select :meeting_id, meetings_for_select,  options: { selected: meeting_selected }, class: "p-form-validation__input", 'aria-invalid': "true"
                p class: "p-form-validation__message", role: "alert" do
                  params.errors.dig(:article, :meeting_id).to_s
                end
              end
            end
          else
            div class: "p-form__group" do
              label  '日程', for: :meeting_id, class: "p-form__label u-align-text--right"
              div class: "p-form__control" do
                select :meeting_id, meetings_for_select, options: { selected: meeting_selected }
              end
            end
          end

          if !params.valid? && params.errors.dig(:article, :categories)
            div class: "p-form__group p-form-validation is-error u-vertically-center" do
              label '議案の種別', for: 'categories', class: "p-form__label u-align-text--right"
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
              label '議案の種別', for: 'categories', class: "p-form__label u-align-text--right"
              div class: "p-form__control" do
                categories.each do |category|
                  if article_categories_selected&.include?(category.id)
                    check_box :categories, name: 'article[categories][]', value: category.id, id: "category-#{category.id}", checked: "checked", class: "p-form-validation__input"
                  else
                    check_box :categories, name: 'article[categories][]', value: category.id, id: "category-#{category.id}", class: "p-form-validation__input"
                  end
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
              label 'タイトル', for: :title, class: "p-form__label u-align-text--right"
              div class: "p-form__control" do
                text_field :title, required: ""
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
              label '本文', for: :body, class: "p-form__label u-align-text--right"
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
              label '本文', for: :body, class: "p-form__label u-align-text--right"
              div class: "p-form__control" do
                text_area :body, rows: 30, required: ""
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
              h4 '下に選択された議案が表示されます。選択を解除するには議案の『×』をクリックしてください。', class: "full-width"
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
              text 'その他の参考議案'
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
              h4 '下に選択された議案が表示されます。選択を解除するには議案の『×』をクリックしてください。', class: "full-width"
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

          submit '保存', class: "p-button--positive u-float-right"
        end
      end
    end
  end
end
