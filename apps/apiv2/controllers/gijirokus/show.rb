module Apiv2::Controllers::Gijirokus
  class Show
    include Apiv2::Action
    accept :jsonapi

    params do
      required(:id).filled(:int?)
    end

    def initialize(jsonapi_repo: JsonapiRepository.new,
                   authenticator: JwtAuthenticator.new)
      @jsonapi_repo = jsonapi_repo
      @authenticator = authenticator
    end

    def call(params)
      if params.valid?
        gijiroku = @jsonapi_repo.find_gijiroku(params[:id])
        halt 404, '{}' unless gijiroku

        self.body = JSON.generate({
          data: {
            type: 'gijirokus',
            id: gijiroku[:id],
            attributes: gijiroku
          }
        })
        self.format = :jsonapi
      else
        self.body = '{}'
        self.status = 400
      end
    end
  end
end
