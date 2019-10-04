module Web::Controllers::Gijiroku
  class Content
    include Web::Action

    def initialize(json_repo: JsonRepository.new,
                   authenticator: JwtAuthenticator.new)
      @json_repo = json_repo
      @authenticator = authenticator
    end

    def call(params)
      gijiroku = @json_repo.latest_gijiroku
      self.body = gijiroku[:body]&.gsub(/(\r\n|\r|\n)/,'<br>') || ''
      self.format = :txt
    end
  end
end
