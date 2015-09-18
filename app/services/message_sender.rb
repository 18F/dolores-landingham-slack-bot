require "slack-ruby-client"

class MessageSender
  def initialize
    configure_slack
  end

  def run
    ScheduledMessage.all.each do |message|
      employee_slack_usernames_for_messages = find_employees(message)

      employee_slack_usernames_for_messages.each do |slack_username|
        channel_id = SlackChannelIdFinder.new(slack_username, client).run

        client.chat_postMessage(
          channel: channel_id,
          as_user: true,
          text: message.body
        )
      end
    end
  end

  private

  def configure_slack
    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end
  end

  def find_employees(message)
    MessageEmployeeMatcher.new(message).run
  end

  def client
    @client ||= Slack::Web::Client.new
  end
end
