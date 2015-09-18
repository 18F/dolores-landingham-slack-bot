require "rails_helper"

describe MessageEmployeeMatcher do
  describe "#run" do
    it "matches messages to users based on days after start" do
      days_after_start = 3
      scheduled_message = create(:scheduled_message, days_after_start: days_after_start)
      _other_message = create(:scheduled_message, days_after_start: 2)
      employee_for_scheduled_message = create(:employee, started_on: days_after_start.days.ago)
      _other_employee = create(:employee, started_on: Date.today)

      matched_employees_and_messages = MessageEmployeeMatcher.new(scheduled_message).run

      expect(matched_employees_and_messages).to eq(
          [ employee_for_scheduled_message.slack_username ]
      )
    end
  end
end
