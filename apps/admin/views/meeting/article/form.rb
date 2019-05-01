module Admin::Views::Meeting
  module Article
    module Form
      def form_for_create(meeting, categories)
        meeting_for_select = { meeting.date => meeting.id }

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

          submit '投稿', class: "p-button--positive u-float-right"
        end
      end

      def form_for_update(meetings, categories, article = nil)
        meetings_for_select = meetings.map { |meeting| [meeting.date, meeting.id] }.to_h
        categories_for_select = categories.map { |category| [category.name, category.id] }.to_h
        article_categories_selected = article&.article_categories&.map(&:category_id)
        meeting_selected = [article&.meeting_id]

        # 採決項目があればvote_contentとして取り出す
        vote_category = article&.categories&.select { |category| category.name == '採決' }&.first
        vote_content = unless vote_category.nil?
          data = article&.article_categories&.select { |data| data.category_id == vote_category.id }.first
          data&.extra_content
        else '' end

        values = article.nil? ? {} : { article: article.to_h.merge(vote_content: vote_content) }

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

          submit '保存', class: "p-button--positive u-float-right"
        end
      end
    end
  end
end
