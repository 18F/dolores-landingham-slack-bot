require "rails_helper"

describe OnboardingMessageSender do
  describe "#run" do
    it "sends onboarding messages to employees" do
      onboarding_message = create(:onboarding_message)
      employee = create(:employee)
      message_sender_double = double(run: true)

      matcher_double = double(run: [employee])
      allow(OnboardingMessageEmployeeMatcher).
        to receive(:new).with(onboarding_message).and_return(matcher_double)
      allow(MessageSender).to receive(:new).with(employee, onboarding_message).and_return(message_sender_double)

      OnboardingMessageSender.new.run

      expect(message_sender_double).to have_received(:run)
    end

    it "sends only active onboarding messages" do
      onboarding_message = create(:onboarding_message)
      onboarding_message2 = create(:onboarding_message, end_date: Date.tomorrow)
      expired_message = create(:onboarding_message, end_date: Date.yesterday)
      employee = create(:employee)
      message_sender_double = double(run: true)

      matcher_double = double(run: [employee])
      allow(OnboardingMessageEmployeeMatcher).
        to receive(:new).with(onboarding_message).and_return(matcher_double)
      allow(OnboardingMessageEmployeeMatcher).
        to receive(:new).with(onboarding_message2).and_return(matcher_double)
      allow(MessageSender).to receive(:new).with(employee, onboarding_message).and_return(message_sender_double)
      allow(MessageSender).to receive(:new).with(employee, onboarding_message2).and_return(message_sender_double)

      OnboardingMessageSender.new.run

      expect(message_sender_double).to have_received(:run).twice
    end
  end
end
