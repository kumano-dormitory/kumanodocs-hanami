require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require_relative '../lib/kumanodocs_hanami'
require_relative '../apps/super/application'
require_relative '../apps/super/application'
require_relative '../apps/admin/application'
require_relative '../apps/web/application'
require_relative '../apps/api/application'
require_relative '../apps/apiv2/application'
require_relative '../apps/api/application'
require_relative '../apps/apiv2/application'

Hanami.configure do
  mount Api::Application, at: '/api/v1'
  mount Apiv2::Application, at: '/api/v2'
  mount Super::Application, at: '/super'
  mount Api::Application, at: '/api/v1'
  mount Apiv2::Application, at: '/api/v2'
  mount Super::Application, at: '/super'
  mount Admin::Application, at: '/admin'
  mount Web::Application, at: '/'

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/kumanodocs_hanami_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/kumanodocs_hanami_development'
    #    adapter :sql, 'mysql://localhost/kumanodocs_hanami_development'
    #
    adapter :sql, ENV['DATABASE_URL']

    ##
    # Migrations
    #
    migrations 'db/migrations'
    schema     'db/schema.sql'
  end

  mailer do
    root 'lib/kumanodocs_hanami/mailers'

    # See http://hanamirb.org/guides/mailers/delivery
    delivery :test
  end

  environment :development do
    # See: http://hanamirb.org/guides/projects/logging
    logger level: :debug
  end

  environment :production do
    logger level: :debug, formatter: :json, filter: %w[password password_confirmation token content], stream: 'logs/hanami.log'

    mailer do
      delivery :smtp, address: ENV['SMTP_HOST'], port: ENV['SMTP_PORT']
    end
  end
end
