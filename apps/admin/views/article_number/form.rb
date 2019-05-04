module Admin::Views::ArticleNumber
  module Form
    def form(meeting, for_download)
      return if meeting.articles.nil?
      max = meeting.articles.count
      button_text = for_download ? '議案順序を確定して資料をダウンロード' : '議案順序を保存'

      form_for :meeting,
               routes.article_number_path(id: meeting.id) + (for_download ? "?download=true" : ''),
               id: "form_for_article_order",
               method: :patch, class: "p-form" do
        hidden_field :meeting_id, value: meeting.id

        button button_text, id: "post_article_order_btn", class: "p-button--positive"
      end
    end
  end
end
