require "rails_helper"
require "business_time"

describe QuarterlyMessageEmployeeMatcher do
  it "sends a quarterly message at/after 9am in the employees time zone to the employee" do
    Timecop.freeze(wed_april_1_nine_am_utc) do
      quarterly_message = create(:quarterly_message)
      _employee_before_9_am_in_their_zone = create(:employee, time_zone: shouldnt_get_message_zone)
      employee_after_9_am_in_their_zone = create(:employee, time_zone: should_get_message_zone)

      matched_employees_and_messages = QuarterlyMessageEmployeeMatcher.new(quarterly_message).run

      expect(matched_employees_and_messages).to match_array [employee_after_9_am_in_their_zone]
    end
  end

  it "matches an employee who already was sent a message last quarter" do
    Timecop.freeze(wed_april_1_nine_am_utc) do
      employee = create(:employee, time_zone: should_get_message_zone)
      quarterly_message = create(:quarterly_message)
      _last_quarters_message = create(
        :sent_message,
        message: quarterly_message,
        employee: employee,
        sent_on: 3.months.ago)

      matched_employees = QuarterlyMessageEmployeeMatcher.new(quarterly_message).run

      expect(matched_employees).to match_array [employee]
    end
  end

  it "does not match an employee who already was sent a message this quarter" do
    Timecop.freeze(wed_april_1_nine_am_utc) do
      employee = create(:employee, time_zone: should_get_message_zone)
      quarterly_message = create(:quarterly_message)
      _this_quarters_message = create(
        :sent_message,
        message: quarterly_message,
        employee: employee,
        sent_on: 3.days.ago
      )

      matched_employees = QuarterlyMessageEmployeeMatcher.new(quarterly_message).run

      expect(matched_employees).to be_empty
    end
  end

  private

  def wed_april_1_nine_am_utc
    Time.parse("2015-4-1 09:00:00 UTC")
  end

  def should_get_message_zone
    time_zone_from_offset(+2)
  end

  def shouldnt_get_message_zone
    time_zone_from_offset(-2)
  end

  def time_zone_from_offset(offset)
    ActiveSupport::TimeZone.new(offset).name
  end
end
