require "rails_helper"

feature "Send test message" do
  scenario "scheduled message sends successfully" do
    create_scheduled_message
    create_employee
    login_with_oauth
    visit scheduled_messages_path

    page.find(".button-test").click
    fill_in "Slack username", with: username_from_fixture
    click_on "Send test"

    expect(page).to have_content("Test message sent")
  end

  scenario "broadcast message sends successfully" do
    create_broadcast_message
    create_employee
    login_with_oauth
    visit broadcast_messages_path

    page.find(".button-test").click
    fill_in "Slack username", with: username_from_fixture
    click_on "Send test"

    expect(page).to have_content("Test message sent")
  end

  scenario "attempt to send test to Slack username that does not exist" do
    create_broadcast_message
    login_with_oauth
    visit broadcast_messages_path

    page.find(".button-test").click
    fill_in "Slack username", with: "notreal"
    click_on "Send test"

    expect(page).to have_content("isn't in the Dolores system")
  end

  scenario "attempt to send test to employee missing Slack info" do
    create_broadcast_message
    create(
      :employee,
      slack_username: username_from_fixture,
      slack_channel_id: nil,
      slack_user_id: nil,
    )

    login_with_oauth
    visit broadcast_messages_path

    page.find(".button-test").click
    fill_in "Slack username", with: username_from_fixture
    click_on "Send test"

    expect(page).to have_content("isn't up to date")
  end

  private

  def create_broadcast_message
    @broadcast_message ||= create(:broadcast_message)
  end

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
