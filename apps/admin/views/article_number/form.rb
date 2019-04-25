module Admin::Views::ArticleNumber
  module Form
    def form(meeting)
      return if meeting.articles.nil?
      max = meeting.articles.count

      form_for :meeting,
               routes.article_number_path(id: meeting.id),
               id: "form_for_article_order",
               method: :patch, class: "p-form" do
        hidden_field :meeting_id, value: meeting.id

        button '議案順序を保存', id: "post_article_order_btn", class: "p-button--positive"
      end
    end
  end
end
