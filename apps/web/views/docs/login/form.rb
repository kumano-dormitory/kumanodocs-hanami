module Web::Views::Docs
  module Login
    module Form
      def form
        values = {'文化部'=>'文化部','炊事部'=>'炊事部','人権擁護部'=>'人権擁護部','庶務部'=>'庶務部','厚生部'=>'厚生部','情報部'=>'情報部','入退寮選考委員会'=>'入退寮選考委員会','資料委員会'=>'資料委員会','監察委員会'=>'監察委員会','選挙管理委員会'=>'選挙管理委員会','居住理由判定委員会'=>'居住理由判定委員会'}

        form_for :user, routes.login_docs_path, method: :post,
                  class: "p-form p-form--stacked" do
          div class: "p-form__group row" do
            div class: "col-2" do
              label '部会・委員会', for: :name, class: "p-form__label"
            end
            div class: "col-9" do
              div class: "p-form__control" do
                select :name, values, required: ""
              end
            end
          end

          div class: "p-form__group row" do
            div class: "col-2" do
              label 'パスワード', for: :password, class: "p-form__label"
            end
            div class: "col-9" do
              div class: "p-form__control" do
                password_field :password, required: ""
              end
            end
          end

          div class: "row" do
            div class: "col-11" do
              submit 'ログイン', class: "p-button--positive u-float-right"
            end
          end
        end
      end
    end
  end
end
