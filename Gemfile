source "https://rubygems.org"

ruby "2.2.3"

gem "jquery-rails"
gem "pg"
gem "puma"
gem "rack-canonical-host"
gem "rails", "~> 4.2.0"
gem "simple_form"
gem "slack-ruby-client"
gem "uglifier"
gem "sass-rails"
gem "omniauth-myusa", github: "18f/omniauth-myusa"

group :development, :test do
  gem "awesome_print"
  gem "bundler-audit", require: false
  gem "byebug"
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.3.0"
end

group :test do
  gem "capybara-webkit", ">= 1.2.0"
  gem "database_cleaner"
  gem "shoulda-matchers", require: false
  gem "simplecov", require: false
  gem "sinatra"
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "rack-timeout"
  gem "rails_12factor"
end 
