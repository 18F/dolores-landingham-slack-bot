require "rails_helper"

feature "Create employees" do
  scenario "successfully" do
    login_with_oauth
    visit root_path

    username = "test_slack_username_3000"
    fill_in "Slack username", with: username
    select "2015", from: "employee_started_on_1i"
    select "June", from: "employee_started_on_2i"
    select "1", from: "employee_started_on_3i"
    click_on "Create Employee"

    expect(page).to have_content("Thanks for adding #{username}")
  end
end
