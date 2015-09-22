require "rails_helper"

feature "View scheduled messages" do
  scenario "sees all message details" do
    visit root_path
    create_scheduled_messages

    click_on "See and/or edit scheduled messages"

    expect(page).to have_content(first_scheduled_message.title)
    expect(page).to have_content(first_scheduled_message.body)
    expect(page).to have_content(second_scheduled_message.title)
    expect(page).to have_content(second_scheduled_message.body)
  end

  private

  def create_scheduled_messages
    first_scheduled_message
    second_scheduled_message
  end

  def first_scheduled_message
    @first_scheduled_message ||= create(:scheduled_message)
  end

  def second_scheduled_message
    @second_scheduled_message ||= create(:scheduled_message)
  end
end
