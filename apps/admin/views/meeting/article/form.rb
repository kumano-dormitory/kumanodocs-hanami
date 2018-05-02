module Admin::Views::Meeting
  module Article
    module Form
      def form_for_create(meetings, categories)
        meetings_for_select = meetings.map { |meeting| [meeting.date, meeting.id] }.to_h
        categories_for_select = categories.map { |category| [category.name, category.id] }.to_h

        form_for :article,
                 routes.meeting_articles_path(meeting_id: params[:meeting_id]),
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

          submit '投稿'
        end
      end

      def form_for_update(meetings, categories, article = nil)
        meetings_for_select = meetings.map { |meeting| [meeting.date, meeting.id] }.to_h
        categories_for_select = categories.map { |category| [category.name, category.id] }.to_h
        values = article.nil? ? {} : { article: article }
        article_categories_selected = article&.article_categories&.map(&:category_id)
        meeting_selected = [article&.meeting_id]

        form_for :article,
                 routes.meeting_article_path(meeting_id: params[:meeting_id], id: params[:id]),
                 method: :patch,
                 values: values do
          unless params.valid?
            div do
              params.errors.to_s
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

          submit '保存'
        end
      end
    end
  end
end
