module Web::Views::Article
  module Form
    def form(meetings, categories)
      meetings_for_select = meetings.map { |meeting| [meeting.date, meeting.id] }.to_h

      form_for :article,
               routes.articles_path,
               method: :post do
        div do
          label  '日程', for: :meeting_id
          select :meeting_id, meetings_for_select
        end

        div do
          label '議案の種別', for: 'article_categories'
          div id: 'article_categories' do
            categories.each do |category|
              check_box :categories, name: 'article[categories][]', value: category.id, id: "category_#{category.id}"
              label     category.name, for: "category_#{category.id}"
            end
          end
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
  end
end