source "https://rubygems.org"

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.2"

gem "audited"
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", require: false
gem "devise"
gem "devise-jwt"
gem "jsonapi-serializer"
gem "jsonapi_errors_handler", github: "jamespearson/jsonapi_errors_handler", branch: "master"

gem "jwt"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "pundit", "~> 2.3"
gem "role_model"
gem "sentry-ruby"
gem "sentry-rails"
gem "sidekiq"
gem "standardrb"
gem "standard-rails"
gem "rack-cors"
gem "redis", ">= 4.0.1"
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "byebug"
  gem "debug", platforms: %i[mri windows]
end

group :development do
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-rails", "~> 1.6", require: false
  gem "capistrano-bundler", "~> 2.0", require: false
end

group :test do
  gem "capybara"
  gem "database_cleaner"
  gem "faker"
  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "shoulda"
end
