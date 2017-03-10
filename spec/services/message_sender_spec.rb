require "rails_helper"

RSpec.shared_examples :message_sender do |message_type|
  let(:message) { create(message_type) }

  it "creates a sent message if sent successfully" do
    Timecop.freeze(Time.parse("10:00:00 UTC"))

    employee = create(:employee)
    mock_slack_channel_finder_for_employee(employee, channel_id: "fake_slack_channel_id")

    allow(SentMessage).to receive(:create)

    MessageSender.new(employee, message).run

    expect(SentMessage).to have_received(:create).with(
      employee: employee,
      message: message,
      sent_on: Date.today,
      sent_at: Time.parse("10:00:00 UTC"),
      error_message: "",
      message_body: message.body,
    )

    Timecop.return
  end

  it "doesn't create a sent message if the test_message option is true" do
    employee = create(:employee)
    mock_slack_channel_finder_for_employee(employee, channel_id: "fake_slack_channel_id")

    allow(SentMessage).to receive(:create)

    MessageSender.new(employee, message, test_message: true).run
    expect(SentMessage).not_to have_received(:create)
  end

  it 'presists the channel id to the employee\'s slack_channel_id field if sent successfully' do
    Timecop.freeze(Time.parse("10:00:00 UTC"))

    employee = create(:employee)
    mock_slack_channel_finder_for_employee(employee, channel_id: "fake_slack_channel_id")

    MessageSender.new(employee, message).run
    expect(employee.reload.slack_channel_id).to eq("fake_slack_channel_id")

    Timecop.return
  end

  it "creates a sent message with error message if error" do
    Timecop.freeze(Time.parse("10:00:00 UTC"))

    employee = create(:employee)
    FakeSlackApi.failure = true
    mock_slack_channel_finder_for_employee(employee, channel_id: "fake_slack_channel_id")

    allow(SentMessage).to receive(:create)

    MessageSender.new(employee, message).run

    expect(SentMessage).to have_received(:create).with(
      employee: employee,
      error_message: "not_authed",
      message: message,
      sent_on: Date.today,
      sent_at: Time.parse("10:00:00 UTC"),
      message_body: message.body,
    )

    Timecop.return
  end

  it "does error if channel not found for slack user" do
    Timecop.freeze(Time.parse("10:00:00 UTC"))

    employee = create(:employee)
    mock_slack_channel_finder_for_employee(employee, channel_id: nil)

    allow(SentMessage).to receive(:create)

    MessageSender.new(employee, message).run

    expect(SentMessage).to have_received(:create).with(
      employee: employee,
      error_message: "Was unable to find a slack channel for user with name #{employee.slack_username} and slack user id #{employee.slack_user_id}",
      message: message,
      sent_on: Date.today,
      sent_at: Time.parse("10:00:00 UTC"),
      message_body: message.body,
    )

    Timecop.return
  end

  it 'persists nil to the employee\'s slack_channel_id if channel id not found for slack user' do
    Timecop.freeze(Time.parse("10:00:00 UTC"))

    employee = create(:employee)
    mock_slack_channel_finder_for_employee(employee, channel_id: nil)

    MessageSender.new(employee, message).run
    expect(employee.reload.slack_channel_id).to be_nil

    Timecop.return
  end
end

RSpec.describe MessageSender do
  include_examples :message_sender, :onboarding_message
  include_examples :message_sender, :quarterly_message
  include_examples :message_sender, :broadcast_message
end
