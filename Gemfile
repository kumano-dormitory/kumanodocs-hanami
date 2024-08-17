source 'https://rubygems.org'

ruby '~> 2.7'

gem 'activesupport', '>= 5.2.4.3'
gem 'hanami', '1.3.5'
gem 'hanami-model'

gem 'pg'
gem 'rake'
gem 'sass'
gem 'tzinfo' , "~>1.0"
gem 'bcrypt'
gem 'jwt'
gem 'openssl', '~> 2.1'
gem 'kramdown'
gem 'kramdown-parser-gfm'

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/projects/code-reloading
  gem 'rubocop'
  gem 'rubocop-performance'
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
  gem 'puma', ">= 5.6.4"
  gem 'tzinfo-data'
end