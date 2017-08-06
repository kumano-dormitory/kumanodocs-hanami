module Admin::Views::ArticleStatus
  module Form
    def form(meeting)
      form_for :meeting,
               routes.article_status_path(id: meeting.id),
               method: :patch do

        meeting.articles.each_with_index do |article, idx|
          div do
            label article.title, for: "meeting-articles-#{idx}-article_id"
            hidden_field :article_id, name: "meeting[articles][][article_id]",
                                      id: "meeting-articles-#{idx}-article_id",
                                      value: article.id
            div do
              check_box :checked, name: "meeting[articles][][checked]",
                                  id: "meeting-articles-#{idx}-checked",
                                  value: true,
                                  checked: article.checked
              label 'checked', for: "meeting-articles-#{idx}-checked"
            end
            div do
              check_box :printed, name: "meeting[articles][][printed]",
                                  id: "meeting-articles-#{idx}-printed",
                                  value: true,
                                  checked: article.printed
              label 'printed', for: "meeting-articles-#{idx}-printed"
            end
          end
        end

        submit 'Send'
      end
    end
  end
end
