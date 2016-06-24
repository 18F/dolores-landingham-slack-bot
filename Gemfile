source "https://rubygems.org"

ruby "2.3.1"

gem "acts-as-taggable-on"
gem "bourbon"
gem "clockwork"
gem "daemons" # for delayed_job
gem "delayed_job_active_record"
gem "foreman"
gem "jquery-rails"
gem "kaminari"
gem "neat"
gem "omniauth-myusa"
gem "paranoia"
gem "pg"
gem "puma"
gem "rack-canonical-host"
gem "rails", "~> 4.2.0"
gem "sass-rails"
gem "simple_form"
gem "slack-ruby-client"
gem "uglifier"
gem "business_time"
gem "holidays"
gem "active_record_union"

group :development, :test do
  gem "awesome_print"
  gem "bundler-audit", require: false
  gem "byebug"
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rspec-rails"
end

group :development do
  gem "rubocop", require: false
end

group :test do
  gem "poltergeist"
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
