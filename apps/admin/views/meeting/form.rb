module Admin::Views::Meeting
  module Form
    def form_create
      form_for :meeting,
               routes.meetings_path,
               method: :post, class: "p-form" do

        if !params.valid? && params.errors.dig(:meeting, :date)
          div class: "p-form-validation is-error" do
            label '日程', for: :date
            date_field :date, class: "p-form-validation__input"
            p class: "p-form-validation__message" do
              if params.errors.dig(:meeting, :date).include?("must be filled")
                strong "この項目は必須です"
              else
                "入力が不正です. もう一度確認してください"
              end
            end
          end
        else
          div do
            label '日程', for: :date
            date_field :date
          end
        end

        if !params.valid? && params.errors.dig(:meeting, :deadline)
          div class: "p-form-validation is-error" do
            label '議案投稿締め切り', for: :deadline
            datetime_local_field :deadline, class: "p-form-validation__input"
            p class: "p-form-validation__message" do
              if params.errors.dig(:meeting, :deadline).include?("must be filled")
                strong "この項目は必須です"
              else
                "入力が不正です. もう一度確認してください"
              end
            end
          end
        else
          div do
            label '議案投稿締め切り', for: :deadline
            datetime_local_field :deadline
          end
        end

        div do
          label "特別な会議の場合はチェックを入れてください。↓複数チェックを入れた場合は一番上のものになります"
          check_box :ryoseitaikai
          label '寮生大会', for: :ryoseitaikai
          check_box :daigiinkai
          label '代議員会', for: :daigiinkai
          check_box :ryoseishukai
          label '寮生集会', for: :ryoseishukai
        end
        submit '作成', class: "p-button--positive"
      end
    end

    def form_update(meeting = nil)
      meeting_values = if meeting
        {meeting: {date: meeting.date, deadline: meeting.deadline.strftime("%Y-%m-%dT%H:%M"), ryoseitaikai: (meeting.type == 1)}}
      else
        {}
      end

      form_for :meeting,
               routes.meeting_path(id: params[:id]),
               values: meeting_values,
               method: :patch, class: "p-form" do

        if !params.valid? && params.errors.dig(:meeting, :date)
          div class: "p-form-validation is-error" do
            label '日程', for: :date
            date_field :date, class: "p-form-validation__input"
            p class: "p-form-validation__message" do
              if params.errors.dig(:meeting, :date).include?("must be filled")
                strong "この項目は必須です"
              else
                "入力が不正です. もう一度確認してください"
              end
            end
          end
        else
          div do
            label '日程', for: :date
            date_field :date
          end
        end

        if !params.valid? && params.errors.dig(:meeting, :deadline)
          div class: "p-form-validation is-error" do
            label '議案投稿締め切り', for: :deadline
            datetime_local_field :deadline, class: "p-form-validation__input"
            p class: "p-form-validation__message" do
              if params.errors.dig(:meeting, :deadline).include?("must be filled")
                strong "この項目は必須です"
              else
                "入力が不正です. もう一度確認してください"
              end
            end
          end
        else
          div do
            label '議案投稿締め切り', for: :deadline
            datetime_local_field :deadline
          end
        end

        div do
          label "特別な会議の場合はチェックを入れてください。↓複数チェックを入れた場合は一番上のものになります"
          check_box :ryoseitaikai
          label '寮生大会', for: :ryoseitaikai
          check_box :daigiinkai
          label '代議員会', for: :daigiinkai
          check_box :ryoseishukai
          label '寮生集会', for: :ryoseishukai
        end

        submit '保存', class: "p-button--positive"
      end
    end
  end
end
