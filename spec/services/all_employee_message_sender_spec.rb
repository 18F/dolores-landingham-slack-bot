require "rails_helper"

describe AllEmployeeMessageSender do
  describe "#run" do
    it "sends the message to all employees and sents the last_sent_at" do
      message = create(:message)
      employees = usernames_from_fixture.map do |username|
        create(:employee, slack_username: username)
      end

      message_sender = double(:message_sender)
      allow(message_sender).to receive(:delay).and_return(double(run: true))
      allow(MessageSender).to receive(:new).and_return(message_sender)

      Timecop.freeze do
        AllEmployeeMessageSender.new(message).run

        employees.each do |employee|
          expect(MessageSender).to have_received(:new).with(employee, message)
          expect(message_sender).to have_received(:delay).exactly(4).times
        end

        expect(message.reload.last_sent_at).
          to be_within(1.second).of Time.current
      end
    end
  end

  def usernames_from_fixture
    %w(testusername testusername2 testusername3 u2)
  end
end
