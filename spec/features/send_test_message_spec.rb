require "rails_helper"

feature "Send test message" do
  scenario "message sends successfully" do
    create_scheduled_message
    create_employee
    login_with_oauth
    visit scheduled_messages_path

    page.find(".button-test").click
    fill_in "Slack username", with: username_from_fixture
    click_on "Send test"

    expect(page).to have_content("Test message sent")
  end

  private

  def create_scheduled_message
    @scheduled_message ||= create(:scheduled_message)
  end

  def create_employee
    @employee ||= create(:employee, slack_username: username_from_fixture)
  end

  def username_from_fixture
    "testusername"
  end
end
