module Web
  module Authentication
    def self.included(action)
      action.class_eval do
        before :authenticate!
      end
    end

    private

    def authenticate!
      if params[:standalone]
        # PWAでのリダイレクトの場合はlocalstorageからtokenを削除する
        redirect_to (routes.login_path + '?standalone=true&invalid=true') unless authenticated?
      else
        redirect_to routes.login_path unless authenticated?
      end
    end

    def authenticated?
      !!(@authenticator&.call(cookies[:token]).verification)
    end
  end
end
