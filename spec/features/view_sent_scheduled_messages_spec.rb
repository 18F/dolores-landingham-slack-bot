require "rails_helper"

feature "View message sent to employees" do
  scenario "see all sent scheduled messages" do
    login_with_oauth
    visit root_path
    create_scheduled_message
    create_employee
    send_scheduled_message_to_employee
    change_scheduled_message_body

    visit sent_scheduled_messages_path

    expect(page).to have_content(original_scheduled_message_body)
    expect(page).to have_content(create_employee.slack_username)
  end

  private

  def create_scheduled_message
    @scheduled_messge ||= create(:scheduled_message, body: original_scheduled_message_body)
  end

  def original_scheduled_message_body
    "original message body"
  end

  def create_employee
    @employee ||= create(:employee)
  end

  def send_scheduled_message_to_employee
    create(
      :sent_scheduled_message,
      message_body: original_scheduled_message_body,
      scheduled_message: create_scheduled_message,
      employee: create_employee
    )
  end

  def change_scheduled_message_body
    create_scheduled_message.update(body: "new message body")
  end
end
