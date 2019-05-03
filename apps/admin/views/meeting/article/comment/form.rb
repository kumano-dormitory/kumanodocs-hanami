module Admin::Views::Meeting
  module Article
    module Comment
      module Form
        def form_update(article_id, block_id, comment, vote_result = nil)

          form_for :comment,
                   routes.comment_path(article_id: article_id, block_id: block_id),
                   method: :patch, class: "p-form" do
            div do
              text_area :body, "#{comment.nil? ? '' : comment.body}", rows: 15
            end

            if vote_result
              div do
                p '採決結果'
                label '賛成', for: :agree
                number_field :agree, value: vote_result.agree,
                             min: 0, step: 1, required: ""
                label '反対', for: :disagree
                number_field :disagree, value: vote_result.disagree,
                            min: 0, step: 1, required: ""
                label '保留', for: :onhold
                number_field :onhold, value: vote_result.onhold,
                             min: 0, step: 1, required: ""
              end
            end

            submit '確定', class: "p-button--positive"
          end
        end
      end
    end
  end
end
