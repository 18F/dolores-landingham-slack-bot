require "rails_helper"

feature "Delete employees" do
  scenario "from list of employees", :js do
    employee = create(:employee)

    login_with_oauth
    visit employees_path
    click_accept_on_javascript_popup do
      page.find(".button-delete").click
    end

    expect(page).to have_content("You deleted #{employee.slack_username}")
  end

  scenario "and re-add" do
    username = "testusername2"
    _employee = create(:employee, slack_username: username)

    login_with_oauth
    visit employees_path
    page.find(".button-delete").click

    visit new_employee_path
    fill_in "Slack username", with: username
    select "2015", from: "employee_started_on_1i"
    select "June", from: "employee_started_on_2i"
    select "1", from: "employee_started_on_3i"
    select "Eastern Time (US & Canada)", from: "employee_time_zone"
    click_on "Create Employee"

    expect(page).to have_content("Thanks for adding #{username}")
  end
end
