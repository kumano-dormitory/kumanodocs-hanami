module Admin::Controllers::Docs
  class Order
    include Admin::Action
    expose :documents

    def initialize(document_repo: DocumentRepository.new,
                   authenticator: AdminAuthenticator.new)
      @document_repo = document_repo
      @authenticator = authenticator
    end

    def call(params)
      @documents = @document_repo.order_by_number
      self.headers.merge!({
        'Content-Security-Policy' => "form-action 'self'; frame-ancestors 'self'; base-uri 'self'; default-src 'none'; manifest-src 'self'; script-src 'self' https://ajax.googleapis.com/ajax/libs/jquery/ https://ajax.googleapis.com/ajax/libs/jqueryui/; connect-src 'self'; img-src 'self' https: data:; style-src 'self' 'unsafe-inline' https:; font-src 'self'; object-src 'none'; plugin-types application/pdf; child-src 'self'; frame-src 'self'; media-src 'self'"
      })
    end
  end
end
