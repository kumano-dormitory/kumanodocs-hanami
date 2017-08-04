source 'https://rubygems.org'

ruby '~> 2.4.1'

gem 'hanami', '~> 1.0'
gem 'hanami-model', github: 'hanami/model', branch: 'develop'

gem 'pg'
gem 'rake'
gem 'sass'
gem 'tzinfo'

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
  gem 'minitest'
end

group :production do
  # gem 'puma'
end
