require "rails_helper"

describe QuarterlyMessageSender do
  describe "#run" do
    it "sends quarterly messages to employees" do
      quarterly_message = create(:quarterly_message)
      employee = create(:employee)
      message_sender_double = double(run: true)

      matcher_double = double(run: [employee])
      allow(QuarterlyMessageEmployeeMatcher).
        to receive(:new).with(quarterly_message).and_return(matcher_double)
      allow(MessageSender).to receive(:new).with(employee, quarterly_message).and_return(message_sender_double)

      QuarterlyMessageSender.new.run

      expect(message_sender_double).to have_received(:run)
    end
  end
end
