module Admin::Views::ArticleNumber
  module Form
    def form(meeting, articles)
      return if articles.nil? || articles.count == 0
      max = articles.count

      form_for :meeting,
               routes.update_article_number_path(id: meeting.id),
               method: :patch do

        articles.each_with_index do |article, idx|
          value = article.number
          div do
            label article.title
            div do
              label 'article number'
              number_field :article_number, min: 1,
                                            max: max,
                                            step: 1,
                                            value: value,
                                            name: "meeting[articles][][number]",
                                            id: "meeting-articles-#{idx}-number"
              hidden_field :article_id, name: "meeting[articles][][article_id]",
                                        value: article.id
            end
          end
        end

        submit 'Send'
      end
    end
  end
end
