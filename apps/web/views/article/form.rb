module Web::Views::Article
  module Form
    def form_create(meetings, categories)
      meetings_for_select = meetings.map { |meeting| [meeting.date, meeting.id] }.to_h
      categories_for_select = categories.map { |category| [category.name, category.id] }.to_h

      form_for :article,
               routes.articles_path,
               method: :post do
        div do
          label  '日程', for: :meeting_id
          select :meeting_id, meetings_for_select
        end

        div do
          label '議案の種別', for: 'categories'
          select :categories, categories_for_select, multiple: true
        end

        div do
          label 'タイトル', for: :title
          text_field :title
        end

        fields_for :author do
          div do
            label '文責', for: :name
            text_field :name
          end

          div do
            label 'パスワード', for: :password
            password_field :password
          end

          div do
            label 'パスワード（確認）', for: :password_confirmation
            password_field :password_confirmation
          end
        end

        div do
          label '本文', for: :body
          text_area :body
        end

        div do
          label '採決項目（議案の種別に「採決」が含まれていない場合には保存されません）', for: :vote_content
          text_area :vote_content
        end

        submit '投稿'
      end
    end

    def form_update(meetings, categories, hash = {})
      article = hash[:article]
      meetings_for_select = meetings.map { |meeting| [meeting.date, meeting.id] }.to_h
      categories_for_select = categories.map { |category| [category.name, category.id] }.to_h
      values = article.nil? ? {} : { article: article }
      article_categories_selected = article&.article_categories&.map(&:category_id)

      # 採決項目があればvote_contentとして取り出す
      vote_category = article&.categories&.select { |category| category.name == '採決' }.first
      vote_content = unless vote_category.nil?
        data = article&.article_categories&.select { |data| data.category_id == vote_category.id }.first
        data&.extra_content
      end

      get_lock = hash[:confirm_update] ? true : false
      meeting_selected = [article&.meeting_id]

      form_for :article,
               routes.article_path(id: params[:id]),
               method: :patch,
               values: values do
        unless params.valid?
          div do
            params.errors.to_s
          end
        end

        if get_lock
          div do
            label 'パスワード', for: :password
            password_field :password
          end
        end

        div do
          label  '日程', for: :meeting_id
          select :meeting_id, meetings_for_select, options: { selected: meeting_selected }
        end

        div do
          label '議案の種別', for: 'categories'
          select :categories, categories_for_select, multiple: true,
                                                     options: {
                                                       selected: article_categories_selected
                                                     }
        end

        div do
          label 'タイトル', for: :title
          text_field :title
        end

        fields_for :author do
          div do
            label '文責', for: :name
            text_field :name
          end
        end

        div do
          label '本文', for: :body
          text_area :body
        end

        div do
          label '採決項目（議案の種別に「採決」が含まれていない場合には保存されません）', for: :vote_content
          text_area :vote_content, vote_content
        end

        div do
          hidden_field :get_lock, value: get_lock
        end

        submit '保存'
      end
    end

    def form_destroy(article)
      form_for :article, routes.article_path(id: article.id), method: :delete, class: 'delete_article' do
        div do
          label 'パスワード', for: :password
          password_field :password
        end

        submit '削除'
      end
    end

    def form_search(keyword)
      form_for :search_article, routes.search_article_path, method: :get, values: {keyword: keyword} do
        div do
          label '検索キーワード', for: :keywords
          text_field :keywords
        end
        submit '検索'
      end
    end
  end
end
