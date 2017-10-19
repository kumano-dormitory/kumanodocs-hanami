module Admin::Views::ArticleNumber
  module Form
    def form(meeting)
      return if meeting.articles.nil?
      max = meeting.articles.count

      form_for :meeting,
               routes.article_number_path(id: meeting.id),
               method: :patch do

        meeting.articles.each_with_index do |article, idx|
          div do
            label article.title, for: "meeting-articles-#{idx}-article-number"
            number_field :article_number, min: 1,
                                          max: max,
                                          step: 1,
                                          value: article.number,
                                          name: "meeting[articles][][number]",
                                          id: "meeting-articles-#{idx}-number"
            hidden_field :article_id, name: "meeting[articles][][article_id]",
                                      id: "meeting-articles-#{idx}-article_id",
                                      value: article.id
          end
        end

        submit 'Send'
      end
    end
  end
end
