module Admin::Views::Message
  module Form
    def form_create(comment)
      form_for :message, routes.messages_path(article_id: comment.article_id, comment_id: comment.id),
                method: :post, class: "p-form" do
        div do
          label '返答者の種別'
          select :send_by_article_author, [['議案提起者として返答', true],["#{comment.block.name}議事録投稿者として返答", false]]
        end

        div do
          label "返答", for: :body
          text_area :body, rows: 10
        end

        submit '送信'
      end
    end

    def form_update(comment, message, values = {})
      form_for :message, routes.message_path(article_id: comment.article_id, comment_id: comment.id, id: message.id),
                method: :patch, class: "p-form" do
        div do
          label '返答者の種別'
          select :send_by_article_author, [['議案提起者として返答', true],["#{comment.block.name}議事録投稿者として返答", false]],
                  options: {selected: values[:send_by_article_author]}
        end

        div do
          label "返答", for: :body
          text_area :body, values[:body], rows: 10
        end

        submit '送信'
      end
    end

    def form_destroy(comment, message)
      form_for :message, routes.message_path(article_id: comment.article_id, comment_id: comment.id, id: message.id),
                method: :delete, class: "p-form" do
        div do
          check_box :check
          label '削除の確認のチェック', for: :check
        end

        submit '削除する', class: "p-button--negative"
      end
    end
  end
end
