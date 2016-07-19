require "rails_helper"

feature "Send message" do
  scenario "message sends successfully", js: true do
    create_message
    create_employee
    login_with_oauth(create(:admin))
    visit messages_path

    page.accept_confirm do
      page.find(".button-send").click
    end

    expect(page).to have_content("Message sent to all users")
  end

  def create_message
    @message ||= create(:message)
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
