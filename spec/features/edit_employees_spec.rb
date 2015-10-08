require "rails_helper"

feature "Edit employees" do
  scenario "from list of employees" do
    old_slack_username = "testusername"
    new_slack_username = "testusername3"
    create(:employee, slack_username: old_slack_username)

    login_with_oauth
    visit employees_path
    click_on "Edit"
    fill_in "Slack username", with: new_slack_username
    click_on "Update Employee"

    expect(page).to have_content "Employee updated successfully"
    expect(page).to have_content new_slack_username
  end

  scenario "unsuccessfully due to an invalid username" do
    old_slack_username = "testusername"
    new_slack_username = "fakeusername3"
    create(:employee, slack_username: old_slack_username)

    login_with_oauth
    visit employees_path
    click_on "Edit"
    fill_in "Slack username", with: new_slack_username
    click_on "Update Employee"

    expect(page).to have_content("There is not a slack user with the username \"#{new_slack_username}\" in your organization.")
  end
end
