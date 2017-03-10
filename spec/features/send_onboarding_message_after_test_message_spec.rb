require "rails_helper"

feature "Send an oboarding message after a test message" do
  scenario "Receiving a test message should not prevent a user from receiving the same scheduled onboarding message" do
    days_after_start = 3
    start_time = Time.parse("11:00:00 UTC")
    employee_time_zone = "Eastern Time (US & Canada)"
    current_time_for_employee = start_time.in_time_zone(employee_time_zone)
    current_time_et_as_utc = Time.zone.utc_to_local(current_time_for_employee)
    message_send_time = days_after_start.business_days.after start_time

    onboarding_message = create(
      :onboarding_message,
      days_after_start: days_after_start,
      time_of_day: current_time_et_as_utc
    )
    employee = create(:employee, started_on: start_time)

    Timecop.freeze(start_time) do
      send_test_onboarding_message(employee, onboarding_message)

      Timecop.travel(days_after_start.business_days.after start_time)

      expect { OnboardingMessageSender.new.run }.to change{ employee.sent_messages.count }.from(0).to(1)
    end
  end

  def send_test_onboarding_message(employee, onboarding_message)
    admin = create(:admin)
    login_with_oauth(admin)
    visit root_path
    visit new_onboarding_message_test_message_path(onboarding_message)
    fill_in :test_message_slack_username, with: employee.slack_username
    click_on "Send test"
  end
end
