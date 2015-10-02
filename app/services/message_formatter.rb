class MessageFormatter
  def initialize(message)
    @message = message
  end

  def escape_slack_characters
    escaped_body = message.body
    escaped_body = escaped_body.gsub('&', '&amp;')
    escaped_body = escaped_body.gsub('<', '&lt;')
    escaped_body = escaped_body.gsub('>', '&gt;')
    escaped_body
  end

  private

  attr_reader :message
end
