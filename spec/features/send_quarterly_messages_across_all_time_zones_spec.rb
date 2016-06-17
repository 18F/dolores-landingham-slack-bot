require "rails_helper"

feature "Create and send quarterly messages to users in every time zone" do
  context "admin user" do
    scenario "can create a quarterly message", :js do
      Timecop.freeze(day_before_quarterly_messages)
      create_employees_from_all_time_zones

      create_a_quarterly_message_via_form
      quarterly_message = ScheduledMessage.first
      simulate_64_hours_of_daily_message_sending

      verify_that_all_employees_got_the_message(quarterly_message)
    end
  end

  #helpers

  def verify_that_all_employees_got_the_message(quarterly_message)
    Employee.all.each do |employee|
      expect(SentScheduledMessage.
             where(employee: employee, scheduled_message: quarterly_message)).not_to be_empty
    end
  end

  def day_before_quarterly_messages
    Time.parse("2015-3-31 00:00:00 UTC")
  end

  def simulate_64_hours_of_daily_message_sending
    64.times do
      fast_forward_one_hour
      DailyMessageSender.new.run
    end
  end

  def create_a_quarterly_message_via_form
    admin = create(:admin)
    login_with_oauth(admin)
    visit root_path
    visit new_scheduled_message_path
    fill_in "Title", with: "Message title"
    fill_in "Message body", with: message_body
    fill_in "Tags", with: "tag_one, tag_two, tag_three"
    check "quarterly"
    click_on "Create Scheduled message"
  end

  def message_body
    "Tax time is coming up!"
  end

  def create_employees_from_all_time_zones
    (-11..13).each do |zone|
      create(:employee, time_zone: time_zone_from_offset(zone))
    end
  end

end

