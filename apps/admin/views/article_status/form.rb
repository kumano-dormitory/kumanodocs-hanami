module Admin::Views::ArticleStatus
  module Form
    def form(meeting)
      form_for :meeting,
               routes.article_status_path(id: meeting.id),
               method: :patch, clas: "p-form" do

        meeting.articles.each_with_index do |article, idx|
          div do
            hidden_field :article_id, name: "meeting[articles][][article_id]",
                                      id: "meeting-articles-#{idx}-article_id",
                                      value: article.id

            label '', for: "meeting-articles-#{idx}-checked" do
              text article.title
              check_box :checked, name: "meeting[articles][][checked]",
                        id: "meeting-articles-#{idx}-checked",
                        class: "p-switch",
                        value: true,
                        checked: article.checked
              div class: "p-switch__slider" do
              end
            end
          end
        end

        submit '保存', class: "p-button--positive"
      end
    end
  end
end
