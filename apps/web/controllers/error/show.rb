module Web::Controllers::Error
  class Show
    include Web::Action

    params do
      required(:id).filled(:int?)
    end

    def call(params)
      if params.valid?
        case params[:id]
        when 400 then
          halt 400
        when 401 then
          halt 401
        when 403 then
          halt 403
        when 404 then
          halt 404
        when 422 then
          halt 422
        when 500 then
          halt 500
        else
          halt 404
        end
      end
      halt 404
    end
  end
end
