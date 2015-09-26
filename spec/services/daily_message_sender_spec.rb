require "rails_helper"

describe DailyMessageSender do
  describe "#run" do
    it "sends scheduled messages to employees" do
      scheduled_message = create(:scheduled_message)
      employee = create(:employee)
      message_sender_double = double(run: true)

      matcher_double = double(run: [employee])
      allow(MessageEmployeeMatcher).
        to receive(:new).with(scheduled_message).and_return(matcher_double)
      allow(MessageSender).to receive(:new).with(employee, scheduled_message).and_return(message_sender_double)

      DailyMessageSender.new.run

      expect(message_sender_double).to have_received(:run)
    end
  end
end
