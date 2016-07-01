source "https://rubygems.org"

ruby "2.3.1"

gem "active_record_union"
gem "acts-as-taggable-on", github: "jessieay/acts-as-taggable-on"
gem "autoprefixer-rails"
gem "business_time"
gem "bourbon"
gem "clockwork"
gem "daemons" # for delayed_job
gem "delayed_job_active_record"
gem "flutie"
gem "foreman"
gem "holidays"
gem "honeybadger"
gem "jquery-rails"
gem "kaminari"
gem "neat"
gem "normalize-rails", "~> 3.0.0"
gem "omniauth-myusa"
gem "paranoia", github: "rubysherpas/paranoia", branch: "core"
gem "pg"
gem "puma"
gem "rack-canonical-host"
gem "rails", "~> 5.0.0"
gem "recipient_interceptor"
gem "sass-rails", "~> 5.0"
gem "simple_form"
gem "slack-ruby-client"
gem "sprockets", ">= 3.0.0"
gem "sprockets-es6"
gem "title"
gem "uglifier"

group :development, :test do
  gem "awesome_print"
  gem "bullet"
  gem "bundler-audit", ">= 0.5.0", require: false
  gem "byebug"
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.5.0.beta4"
end

group :development do
  gem "rubocop", require: false
end

group :test do
  gem "poltergeist"
  gem "capybara", ">= 2.6.2"
  gem "database_cleaner"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "sinatra", github: "sinatra/sinatra"
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "rack-timeout"
  gem "rails_stdout_logging"
end
