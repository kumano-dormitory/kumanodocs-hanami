module Admin::Views::Sessions
  module Form
    def form
      form_for :session, routes.sessions_path, method: :post,
                class: "p-form p-form--stacked" do
        div class: "p-form__group" do
          label 'ユーザー名', for: :name, class: "p-form__label"
          div class: "p-form__control" do
            text_field :name, required: ""
          end
        end

        div class: "p-form__group" do
          label 'パスワード', for: :password, class: "p-form__label"
          div class: "p-form__control" do
            password_field :password, required: ""
          end
        end

        submit 'ログイン', class: "p-button--positive u-float-right"
      end
    end
  end
end
