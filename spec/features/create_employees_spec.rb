require "rails_helper"

feature "Create employees" do
  scenario "successfully" do
    username = "testusername2"
    login_with_oauth

    visit new_employee_path
    fill_in "Slack username", with: username
    select "2015", from: "employee_started_on_1i"
    select "June", from: "employee_started_on_2i"
    select "1", from: "employee_started_on_3i"
    select "Eastern Time (US & Canada)", from: "employee_time_zone"
    click_on "Create Employee"

    expect(page).to have_content("Thanks for adding #{username}")
  end

  scenario "with short username" do
    username = "u2"
    login_with_oauth

    visit new_employee_path
    fill_in "Slack username", with: username
    select "2015", from: "employee_started_on_1i"
    select "June", from: "employee_started_on_2i"
    select "1", from: "employee_started_on_3i"
    select "Eastern Time (US & Canada)", from: "employee_time_zone"
    click_on "Create Employee"

    expect(page).to have_content("Thanks for adding #{username}")
  end

  scenario "unsuccessfully with invalid username" do
    username = "fakeusername2"
    login_with_oauth

    visit new_employee_path
    fill_in "Slack username", with: username
    select "2015", from: "employee_started_on_1i"
    select "June", from: "employee_started_on_2i"
    select "1", from: "employee_started_on_3i"
    select "Eastern Time (US & Canada)", from: "employee_time_zone"
    click_on "Create Employee"

    expect(page).to have_content("There is not a slack user with the username \"#{username}\" in your organization.")
  end
end
