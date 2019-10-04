module Api
  module Authentication
    def self.included(action)
      action.class_eval do
        before :authenticate!
      end
    end

    private

    def authenticate!
      halt 403 unless authenticated?
    end

    def authenticated?
      token = params.env['HTTP_AUTHORIZATION']&.slice(7.. -1) || params[:token]

      !!(@authenticator&.call(token).verification)
    end
  end
end
