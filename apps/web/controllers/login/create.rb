require 'jwt'

module Web::Controllers::Login
  class Create
    include Web::Action
    expose :standalone

    params do
      required(:login).schema do
        required(:name).filled(:str?)
        required(:password).filled(:str?)
      end
      optional(:standalone).filled(:bool?)
    end

    def initialize(user_repo: UserRepository.new)
      @user_repo = user_repo
    end

    def call(params)
      @standalone = !!params[:standalone]
      if params.valid?
        user = @user_repo.find_by_name(params[:login][:name])
        if !user.nil? && user.authority == 0 && user.authenticate(params[:login][:password])
          if @standalone
            cookies[:token] = {
              value: generate_token(user.name, ENV['KUMANODOCS_AUTH_TOKEN_VERSION']),
              path: '/',
              httponly: false,
              max_age: (3600 * 24 * 30)
            }
            redirect_to routes.root_path + '?loggedin=true'
          else
            cookies[:token] = {
              value: generate_token(user.name, ENV['KUMANODOCS_AUTH_TOKEN_VERSION']),
              path: '/',
              httponly: true
            }
            redirect_to routes.root_path
          end
        end
      end
      cookies[:token] = nil
    end

    def generate_token(name, version, exp_day = 7)
      rsa_private = OpenSSL::PKey::RSA.new(ENV['KUMANODOCS_AUTH_TOKEN_PKEY'])
      exp = Time.now.to_i + (exp_day * 24 * 3600)
      payload = {
        id: name,
        version: version,
        exp: exp
      }
      JWT.encode(payload, rsa_private, 'RS256')
    end

    def authenticate!
      # do nothing
    end
  end
end
