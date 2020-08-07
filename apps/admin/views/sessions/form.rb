module Admin::Views::Sessions
  module Form
    def form
      form_for :session, routes.sessions_path, method: :post,
                class: "p-form p-form--stacked" do
        div class: "p-form__group row" do
          div class: "col-2" do
            label 'ユーザー名', for: :adminname, class: "p-form__label u-align-text--right"
          end
          div class: "col-8" do
            div class: "p-form__control" do
              text_field :adminname, required: ""
            end
          end
        end

        div class: "p-form__group row" do
          div class: "col-2" do
            label 'パスワード', for: :password, class: "p-form__label u-align-text--right"
          end
          div class: "col-8" do
            div class: "p-form__control" do
              password_field :password, required: ""
            end
          end
        end

        div class: "row" do
          div class: "col-10" do
            submit 'ログイン', class: "p-button--positive u-float-right"
          end
        end
      end
    end
  end
end
