require "rails_helper"

describe SentScheduledMessage do
  describe "Associations" do
    it { should belong_to(:employee).dependent(:destroy) }
    it { should belong_to(:scheduled_message).dependent(:destroy) }
  end

  describe "Validations" do
    it { should validate_presence_of(:employee) }
    it { should validate_presence_of(:message_body) }
    it { should validate_presence_of(:scheduled_message) }
    it { should validate_presence_of(:sent_at) }
    it { should validate_presence_of(:sent_on) }

    it "validates employee uniqueness scoped to scheduled message" do
      employee = build_stubbed(:employee)
      scheduled_message = build_stubbed(:scheduled_message)
      create(
        :sent_scheduled_message,
        employee: employee,
        scheduled_message: scheduled_message,
      )

      duplicate_sent_scheduled_message = build(
        :sent_scheduled_message,
        employee: employee,
        scheduled_message: scheduled_message,
      )

      expect(duplicate_sent_scheduled_message).not_to be_valid
    end
  end

  describe "Delegated methods" do
    it { should delegate_method(:slack_username).to(:employee) }
  end
end
