require "rails_helper"

feature "Create quarterly message" do
  context "admin user" do
    scenario "can create a quarterly message", :js do
      create_a_quarterly_message_via_form

      expect(page).to have_content("Scheduled message created successfully")
      expect(ScheduledMessage.count).to eq 1
    end

    scenario "can create a quarterly message that goes out to employees on the right day", :js do
      create_a_quarterly_message_via_form
      employee = create(:employee, time_zone: should_get_message_zone)
      Timecop.freeze(wed_april_1_nine_am_utc)

      DailyMessageSender.new.run

      latest_sent = SentScheduledMessage.last
      expect(latest_sent.employee).to eq employee
      expect(latest_sent.message_body).to eq message_body
    end

    scenario "can create a quarterly message that doesn't go out to employees on the wrong day", :js do
      create_a_quarterly_message_via_form
      create(:employee, time_zone: should_get_message_zone)
      Timecop.freeze(wed_april_1_nine_am_utc - 7.days)

      DailyMessageSender.new.run

      expect(SentScheduledMessage.count).to eq 0
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

  def wed_april_1_nine_am_utc
    Time.parse("2015-4-1 09:00:00 UTC")
  end

  def time_zone_from_offset(offset)
    ActiveSupport::TimeZone.new(offset).name
  end

  def should_get_message_zone
    time_zone_from_offset(+2)
  end

end

