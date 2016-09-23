require "rails_helper"

describe TimeZoneDisplayHelper do
  describe "#display_local_time_zone" do
    it "formats for Eastern Time (US & Canada)" do
      sent_message = create(:sent_message)

      time_display = display_local_time_zone(sent_message)

      sent_message.sent_at.in_time_zone(sent_message.employee.time_zone).dst? ?
        expected_time_display = "6:00 AM (EDT)" :
        expected_time_display = "5:00 AM (EST)"

      expect(time_display).to eq(expected_time_display)
    end

    it "formats for Central Time (US & Canada)" do
      employee = create(:employee, time_zone: "Central Time (US & Canada)")
      sent_message = create(:sent_message, employee: employee)

      time_display = display_local_time_zone(sent_message)

      sent_message.sent_at.in_time_zone(sent_message.employee.time_zone).dst? ?
        expected_time_display = "5:00 AM (CDT)" :
        expected_time_display = "4:00 AM (CST)"

      expect(time_display).to eq(expected_time_display)
    end

    it "formats for Mountain Time (US & Canada)" do
      employee = create(:employee, time_zone: "Mountain Time (US & Canada)")
      sent_message = create(:sent_message, employee: employee)

      time_display = display_local_time_zone(sent_message)

      sent_message.sent_at.in_time_zone(sent_message.employee.time_zone).dst? ?
        expected_time_display = "4:00 AM (MDT)" :
        expected_time_display = "3:00 AM (MST)"

      expect(time_display).to eq(expected_time_display)
    end

    it "formats for Pacific Time (US & Canada)" do
      employee = create(:employee, time_zone: "Pacific Time (US & Canada)")
      sent_message = create(:sent_message, employee: employee)

      time_display = display_local_time_zone(sent_message)

      sent_message.sent_at.in_time_zone(sent_message.employee.time_zone).dst? ?
        expected_time_display = "3:00 AM (PDT)" :
        expected_time_display = "2:00 AM (PST)"

      expect(time_display).to eq(expected_time_display)
    end
  end
end
