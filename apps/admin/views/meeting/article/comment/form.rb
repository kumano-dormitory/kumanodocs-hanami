module Admin::Views::Meeting
  module Article
    module Comment
      module Form
        def form_update(article_id, block_id, comment)

          form_for :comment,
                   routes.comment_path(article_id: article_id, block_id: block_id),
                   method: :patch do
            div do
              text_area :body, "#{comment.nil? ? '' : comment.body}"
            end
            submit '確定'
          end
        end
      end
    end
  end
end
