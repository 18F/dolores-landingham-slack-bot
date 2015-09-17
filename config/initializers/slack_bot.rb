require 'slack-ruby-client'
require 'dotenv'

Dotenv.load

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

# client = Slack::Web::Client.new

# puts client.auth_test
