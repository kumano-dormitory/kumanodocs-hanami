source 'https://rubygems.org'

ruby '~> 2.6'

gem 'activesupport'
gem 'hanami', '~> 1.2'
gem 'hanami-model', '~> 1.2'

gem 'pg'
gem 'rake'
gem 'sass'
gem 'tzinfo'
gem 'bcrypt'
gem 'jwt'
gem 'openssl', '~> 2.1'

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/projects/code-reloading
  gem 'rubocop'
  gem 'shotgun'
end

group :test, :development do
  gem 'dotenv', '~> 2.0'
  gem 'faker'
end

group :test do
  gem 'capybara'
  gem 'factory_bot'
  gem 'minitest'
end

group :production do
  gem 'puma'
  gem 'tzinfo-data'
end
