module Admin::Views::ArticleNumber
  module Form
    def form(meeting)
      return if meeting.articles.nil? || meeting.articles.count == 0
      max = meeting.articles.count

      form_for :meeting,
               routes.article_number_path(id: meeting.id),
               method: :patch do

        meeting.articles.each_with_index do |article, idx|
          value = article.number
          div do
            label article.title, for: "meeting-articles-#{idx}-article_id"
            hidden_field :article_id, name: "meeting[articles][][article_id]",
                                      id: "meeting-articles-#{idx}-article_id",
                                      value: article.id
            label 'article number', for: "meeting-articles-#{idx}-number"
            number_field :article_number, name: "meeting[articles][][number]",
                                          id: "meeting-articles-#{idx}-number",
                                          min: 1,
                                          max: max,
                                          step: 1,
                                          value: value
          end
        end

        submit 'Send'
      end
    end
  end
end
