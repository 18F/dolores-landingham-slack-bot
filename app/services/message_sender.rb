require "slack-ruby-client"

class MessageSender
  def initialize
    configure_slack
  end

  def run
    ScheduledMessage.all.each do |message|
      employees_for_message = find_employees(message)

      employees_for_message.each do |employee|
        channel_id = SlackChannelIdFinder.new(employee.slack_username, client).run

        begin
          post_message(channel_id: channel_id, message: message)
          create_sent_scheduled_message(
            employee: employee,
            scheduled_message: message,
            error: nil,
          )
        rescue Slack::Web::Api::Error => error
          create_sent_scheduled_message(
            employee: employee,
            scheduled_message: message,
            error: error,
          )
        end
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

  def post_message(options)
    client.chat_postMessage(
      channel: options[:channel_id],
      as_user: true,
      text: options[:message].body
    )
  end

  def create_sent_scheduled_message(options)
    SentScheduledMessage.create(
      employee: options[:employee],
      scheduled_message: options[:scheduled_message],
      sent_on: Date.current,
      error_message: error_message(options[:error]),
      message_body: options[:scheduled_message].body,
    )
  end

  def error_message(error)
    if error
      error.message
    else
      ""
    end
  end
end
