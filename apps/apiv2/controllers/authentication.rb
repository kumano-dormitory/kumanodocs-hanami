module Apiv2
  module Authentication
    def self.included(action)
      action.class_eval do
        before :authenticate!
      end
    end

    private

    def authenticate!
      halt 403, '{"errors":[{"status":"403","title":"Forbidden"}]}' unless authenticated?
    end

    def authenticated?
      token = params.env['HTTP_AUTHORIZATION']&.slice(7.. -1)

      !!(@authenticator&.call(token).verification)
    end
  end
end