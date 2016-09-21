require "rails_helper"

feature "View message sent to employees" do
  scenario "see all sent scheduled messages" do
    login_with_oauth
    visit root_path
    create_message
    create_employee
    send_message_to_employee
    change_message_body

    visit sent_messages_path

    expect(page).to have_content(original_message_body)
    expect(page).to have_content(create_employee.slack_username)
  end

  private

  def create_message
    @message ||= create(:onboarding_message, body: original_message_body)
  end

  def original_message_body
    "original message body"
  end

  def create_employee
    @employee ||= create(:employee)
  end

  def send_message_to_employee
    create(
      :sent_message,
      message_body: original_message_body,
      message: create_message,
      employee: create_employee
    )
  end

  def change_message_body
    create_message.update(body: "new message body")
  end
end
