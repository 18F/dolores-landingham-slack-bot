require "rails_helper"

describe MessageSender do
  describe "#run" do
    it "sends scheduled messages to employees" do
      scheduled_message = create(:scheduled_message)
      employee = create(:employee)
      matcher_double = double(run: [employee.slack_username])
      client_double = double(chat_postMessage: true)
      slack_channel_id = "fake_slack_channel_id"
      slack_channel_finder_double = double(run: slack_channel_id)
      allow(Slack::Web::Client).to receive(:new).and_return(client_double)
      allow(MessageEmployeeMatcher).
        to receive(:new).with(scheduled_message).and_return(matcher_double)
      allow(SlackChannelIdFinder).
        to receive(:new).with(employee.slack_username, client_double).
        and_return(slack_channel_finder_double)


      MessageSender.new.run

      expect(client_double).to have_received(:chat_postMessage).with(
        channel: slack_channel_id,
        as_user: true,
        text: scheduled_message.body
      )
    end
  end
end
