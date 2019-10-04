module Admin
  module Controllers
    module Authentication
      def self.included(action)
        action.class_eval do
          before :authenticate!
          expose :current_user
        end
      end

      private

      def authenticate!
        redirect_to routes.new_session_path unless authenticated?
      end

      def authenticated?
        !!current_user
      end

      def current_user
        @current_user ||= @authenticator&.call(session[:user_id])&.user
      end
    end
  end
end
