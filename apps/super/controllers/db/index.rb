module Super::Controllers::Db
  class Index
    include Super::Action
    expose :result

    def initialize()
    end

    def call(params)
      self.headers.merge!({
        'Content-Security-Policy' => "form-action 'self'; frame-ancestors 'self'; base-uri 'self'; default-src 'none'; manifest-src 'self'; script-src 'self' https://code.jquery.com/; connect-src 'self'; img-src 'self' https: data:; style-src 'self' 'unsafe-inline' https:; font-src 'self'; object-src 'none'; plugin-types application/pdf; child-src 'self'; frame-src 'self'; media-src 'self'"
      })
    end
  end
end
