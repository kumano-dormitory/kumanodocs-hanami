module Web::Views::Comment
  module Form
    def form_update(meeting, block_id, comment_datas = nil, vote_result_datas = nil)

      form_for :comments,
               routes.comments_path(meeting_id: meeting.id, block_id: block_id),
               method: :patch,
               class: "p-form" do

        if !params.valid? && params.errors.dig(:comments, :password)
          div class: "p-form-validation is-error" do
            label "パスワード", for: :password
            password_field :password, class: "p-form-validation__input", autocomplete: "new-password", required: ""
            p class: "p-form-validation__message" do
              if params.errors.dig(:comments, :password).include?("must be filled")
                strong "この項目は必須です"
              else
                "入力が不正です 文字列を入力してください"
              end
            end
          end
        else
          div do
            label "パスワード", for: :password
            password_field :password, autocomplete: "new-password", required: ""
          end
        end

        meeting.articles.each_with_index do |article, idx|
          comment_data = comment_datas&.find{ |data| data[:article_id] == article.id }
          vote_result = vote_result_datas&.find{ |data| data[:article_id] == article.id }&.fetch(:vote_result, nil)

          fieldset '', style: "margin-bottom:1.5rem;" do
            div do
              label "#{article_formatted_title(article, checked: true, number: true)}への議事録", for: "meeting-articles-#{idx}-comment", class: "p-heading--four"
            end
            div do
              text_area :comment,
                        "#{comment_data.nil? ? '' : comment_data[:comment]}",
                        name: "meeting[articles][][comment]",
                        id: "meeting-articles-#{idx}-comment",
                        rows: 10
              hidden_field :article_id, value: article.id,
                        name: "meeting[articles][][article_id]",
                        id: "meeting-articles-#{idx}-article_id"
            end

            if article.categories.find_index { |category| category.require_content && category.name == '採決' }
              div do
                p '採決結果'
                label '賛成', for: "meeting-articles-#{idx}-vote_result-agree"
                number_field :agree, value: vote_result&.fetch(:agree),
                             name: "meeting[articles][][vote_result][agree]",
                             id: "meeting-articles-#{idx}-vote_result-agree",
                             min: 0, step: 1, required: ""
                label '反対', for: "meeting-articles-#{idx}-vote_result-disagree"
                number_field :disagree, value: vote_result&.fetch(:disagree),
                            name: "meeting[articles][][vote_result][disagree]",
                            id: "meeting-articles-#{idx}-vote_result-disagree",
                            min: 0, step: 1, required: ""
                label '保留', for: "meeting-articles-#{idx}-vote_result-onhold"
                number_field :onhold, value: vote_result&.fetch(:onhold),
                             name: "meeting[articles][][vote_result][onhold]",
                             id: "meeting-articles-#{idx}-vote_result-onhold",
                             min: 0, step: 1, required: ""
              end
            end
          end
        end

        submit '投稿', class: "p-button--positive"
      end
    end
  end
end
