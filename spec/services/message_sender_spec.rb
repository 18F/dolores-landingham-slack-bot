require "rails_helper"

describe MessageSender do
  it "creates a sent scheduled message if sent successfully" do
    Timecop.freeze(Time.parse("10:00:00 UTC"))

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
      sent_on: Date.today,
      sent_at: Time.parse("10:00:00 UTC"),
      error_message: "",
      message_body: scheduled_message.body,
    )

    Timecop.return
  end

  it 'presists the channel id to the employee\'s slack_channel_id field if sent successfully' do
    Timecop.freeze(Time.parse("10:00:00 UTC"))

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
    expect(employee.reload.slack_channel_id).to eq('fake_slack_channel_id')

    Timecop.return
  end

  it "creates a sent scheduled message with error message if error" do
    Timecop.freeze(Time.parse("10:00:00 UTC"))

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
      sent_on: Date.today,
      sent_at: Time.parse("10:00:00 UTC"),
      message_body: scheduled_message.body,
    )

    Timecop.return
  end

  it "does not error if channel not found for slack user" do
    Timecop.freeze(Time.parse("10:00:00 UTC"))

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

    Timecop.return
  end

  it 'persists nil to the employee\'s slack_channel_id if channel id not found for slack user' do
    Timecop.freeze(Time.parse("10:00:00 UTC"))

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
    expect(employee.reload.slack_channel_id).to be_nil

    Timecop.return
  end
end
