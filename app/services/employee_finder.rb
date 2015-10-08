require "slack-ruby-client"

class EmployeeFinder
  def initialize(slack_username)
    @slack_username = slack_username
    configure_slack
  end

  def existing_employee?
    SlackUserFinder.new(@slack_username, client).existing_user?
  end

  private

  def configure_slack
    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end
  end

  def client
    @client ||= Slack::Web::Client.new
  end
end
