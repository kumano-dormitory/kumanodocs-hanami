module Admin::Views::Meeting
  module Form
    def form
      form_for :meeting,
               routes.meetings_path,
               method: :post do
        div do
          label '日程', for: :date
          date_field :date
        end

        div do
          label '議案投稿締め切り', for: :deadline
          datetime_local_field :deadline
        end

        submit '作成'
      end
    end
  end
end
