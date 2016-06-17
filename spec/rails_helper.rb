ENV["RAILS_ENV"] = "test"
ENV["AUTH_DOMAIN"] = "example.com"
ENV["TZ"] = "UTC"

require File.expand_path("../../config/environment", __FILE__)
abort("DATABASE_URL environment variable is set") if ENV["DATABASE_URL"]

require "rspec/rails"
require "shoulda/matchers"
require "capybara/poltergeist"

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |file| require file }

module Features
  include OauthHelper
end

include TimeHelper

RSpec.configure do |config|
  config.before(:each) do
    FakeSlackApi.failure = false
    stub_request(:any, /slack.com/).to_rack(FakeSlackApi)
  end

  config.include Rails.application.routes.url_helpers
  config.include Features, type: :feature
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false
end

ActiveRecord::Migration.maintain_test_schema!
Capybara.javascript_driver = :poltergeist
OmniAuth.config.test_mode = true

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
