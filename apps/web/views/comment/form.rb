module Web::Views::Comment
  module Form
    def form_update(meeting, block_id, datas)

      form_for :comments,
               routes.comments_path(meeting_id: meeting.id, block_id: block_id),
               method: :patch do

        meeting.articles.each_with_index do |article, idx|
          comment_data = datas.find{ |data| data[:article_id] == article.id }

          div do
            div do
              label "#{article.title}への議事録", for: "meeting-articles-#{idx}-comment"
            end
            div do
              text_area :comment,
                        "#{comment_data.nil? ? '' : comment_data[:comment]}",
                        name: "meeting[articles][][comment]",
                        id: "meeting-articles-#{idx}-comment"
              hidden_field :article_id, value: article.id,
                        name: "meeting[articles][][article_id]",
                        id: "meeting-articles-#{idx}-article_id"
            end
          end
        end

        submit '投稿'
      end
    end
  end
end
