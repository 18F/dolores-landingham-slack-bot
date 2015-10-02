require "rails_helper"

describe MessageFormatter do
  describe "#escape_slack_characters" do
    it "escapes specific characters (&, <, and >) as defined by the Slack Message API" do
      scheduled_message = create(
        :scheduled_message,
        body: "This is a \"message\" with &, <, and > characters that should be escaped and some 'others' that _should_ *not* be!"
      )
      formatted_message_body = MessageFormatter.new(scheduled_message).escape_slack_characters

      expect(formatted_message_body).to eq(
          "This is a \"message\" with &amp;, &lt;, and &gt; characters that should be escaped and some 'others' that _should_ *not* be!",
      )
    end
  end
end
