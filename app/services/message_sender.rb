require "slack-ruby-client"

class MessageSender
  def initialize(employee, message)
    @employee = employee
    @message = message
  end

  def run
    configure_slack

    if employee.slack_channel_id.nil?
      channel_id = SlackChannelIdFinder.new(employee.slack_username, client).run
      employee.slack_channel_id = channel_id
      employee.save
    end

    if employee.slack_channel_id
      begin
        post_message(channel_id: employee.slack_channel_id, message: message)
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

  private

  attr_reader :employee, :message

  def configure_slack
    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end
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
      sent_at: Time.current,
      error_message: error_message(options[:error]),
      message_body: MessageFormatter.new(options[:scheduled_message]).escape_slack_characters
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
