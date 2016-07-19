require "slack-ruby-client"

class MessageSender
  def initialize(employee, message)
    @employee = employee
    @message = message
  end

  def run
    slack_user_id = EmployeeFinder.new(employee.slack_username).slack_user_id

    if employee.slack_user_id.nil? && slack_user_id.present?
      employee.slack_user_id = slack_user_id
      employee.save
    end

    if employee.slack_channel_id.nil?
      channel_id = SlackChannelIdFinder.new(employee.slack_user_id, client).run
      employee.slack_channel_id = channel_id
      employee.save
    end

    if employee.slack_channel_id.present?
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
    else
      create_sent_scheduled_message(
        employee: employee,
        scheduled_message: message,
        error: StandardError.new("Was unable to find a slack channel for user with name #{employee.slack_username} and slack user id #{employee.slack_user_id}"),
      )
    end

  end

  private

  attr_reader :employee, :message

  def client
    @client ||= Slack::Web::Client.new
  end

  def post_message(options)
    client.chat_postMessage(
      channel: options[:channel_id],
      as_user: true,
      text: options[:message].body,
    )
  end

  def create_sent_scheduled_message(options)
    SentScheduledMessage.create(
      employee: options[:employee],
      scheduled_message: options[:scheduled_message],
      sent_on: Date.current,
      sent_at: Time.current,
      error_message: error_message(options[:error]),
      message_body: formatted_message(options),
    )
  end

  def error_message(error)
    if error
      error.message
    else
      ""
    end
  end

  def formatted_message(options)
    MessageFormatter.new(options[:scheduled_message]).escape_slack_characters
  end
end
