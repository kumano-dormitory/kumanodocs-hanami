module Super
  module Helpers
    module UserHelper
      def user_role(authority)
        case authority
        when 0 then
          "一般ユーザ"
        when 1 then
          "部会・委員会ユーザ"
        when 2 then
          "資料委員会ユーザ"
        when 3 then
          "管理者ユーザ"
        else
          "(不明なユーザ)"
        end
      end
    end
  end
end
