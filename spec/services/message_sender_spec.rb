require "rails_helper"

describe MessageSender do
  it "creates a sent scheduled message if sent successfully" do
    scheduled_message = create(:scheduled_message)
    employee = create(:employee)
    client_double = Slack::Web::Client.new
    slack_channel_id = "fake_slack_channel_id"
    slack_channel_finder_double = double(run: slack_channel_id)

    allow(Slack::Web::Client).to receive(:new).and_return(client_double)
    allow(SlackChannelIdFinder).
      to receive(:new).with(employee.slack_username, client_double).
      and_return(slack_channel_finder_double)
    allow(SentScheduledMessage).to receive(:create)


    MessageSender.new(employee, scheduled_message).run

    expect(SentScheduledMessage).to have_received(:create).with(
      employee: employee,
      scheduled_message: scheduled_message,
      sent_on: Date.current,
      error_message: "",
      message_body: scheduled_message.body,
    )
  end

  it "creates a sent scheduled message with error message if error" do
    scheduled_message = create(:scheduled_message)
    employee = create(:employee)
    client_double = Slack::Web::Client.new
    slack_channel_id = "fake_slack_channel_id"
    slack_channel_finder_double = double(run: slack_channel_id)
    FakeSlackApi.failure = true

    allow(Slack::Web::Client).to receive(:new).and_return(client_double)
    allow(SlackChannelIdFinder).
      to receive(:new).with(employee.slack_username, client_double).
      and_return(slack_channel_finder_double)
    allow(SentScheduledMessage).to receive(:create)


    MessageSender.new(employee, scheduled_message).run

    expect(SentScheduledMessage).to have_received(:create).with(
      employee: employee,
      error_message: "not_authed",
      scheduled_message: scheduled_message,
      sent_on: Date.current,
      message_body: scheduled_message.body,
    )
  end

  it "does not error if channel not found for slack user" do
    scheduled_message = create(:scheduled_message)
    employee = create(:employee)
    client_double = Slack::Web::Client.new
    slack_channel_id_double = double(run: nil)

    allow(Slack::Web::Client).to receive(:new).and_return(client_double)
    allow(SlackChannelIdFinder).
      to receive(:new).with(employee.slack_username, client_double).
      and_return(slack_channel_id_double)
    allow(SentScheduledMessage).to receive(:create)

    MessageSender.new(employee, scheduled_message).run

    expect(SentScheduledMessage).not_to have_received(:create)
  end
end
