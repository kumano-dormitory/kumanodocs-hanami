module Apiv2::Controllers::Gijirokus
  class Index
    include Apiv2::Action
    accept :jsonapi

    def initialize(jsonapi_repo: JsonapiRepository.new,
                   authenticator: JwtAuthenticator.new)
      @jsonapi_repo = jsonapi_repo
      @authenticator = authenticator
    end

    def call(params)
      gijirokus = @jsonapi_repo.gijirokus_list.map do |gijiroku|
        {
          type: 'gijirokus',
          id: gijiroku[:id],
          attributes: gijiroku
        }
      end
      self.body = JSON.generate({
        data: gijirokus
      })
      self.format = :jsonapi
    end
  end
end
