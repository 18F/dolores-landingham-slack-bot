require "rails_helper"

feature "View scheduled messages" do
  scenario "sees all message details" do
    login_with_oauth
    visit root_path
    create_scheduled_messages

    visit scheduled_messages_path

    expect(page).to have_content(first_scheduled_message.title)
    expect(page).to have_content(first_scheduled_message.body)
    expect(page).to have_content(first_scheduled_message.days_after_start)
    expect(page).to have_content(first_scheduled_message.time_of_day.strftime("%l:%M %p"))
    expect(page).to have_content(second_scheduled_message.title)
    expect(page).to have_content(second_scheduled_message.body)
    expect(page).to have_content(second_scheduled_message.days_after_start)
    expect(page).to have_content(second_scheduled_message.time_of_day.strftime("%l:%M %p"))
  end

  scenario "sees pagination controls" do
    allow(Kaminari.config).to receive(:default_per_page).and_return(1)

    login_with_oauth
    visit root_path
    create_scheduled_messages

    visit scheduled_messages_path

    expect(page).to have_content(first_scheduled_message.title)
    expect(page).to have_content(first_scheduled_message.body)
    expect(page).to have_content(first_scheduled_message.days_after_start)
    expect(page).to have_content(first_scheduled_message.time_of_day.strftime("%l:%M %p"))

    expect(page).not_to have_content(second_scheduled_message.title)

    expect(page).to have_content("Next")
    expect(page).to have_content("Last")

    click_on "Last"

    expect(page).not_to have_content(first_scheduled_message.title)

    expect(page).to have_content(second_scheduled_message.title)
    expect(page).to have_content(second_scheduled_message.body)
    expect(page).to have_content(second_scheduled_message.days_after_start)
    expect(page).to have_content(second_scheduled_message.time_of_day.strftime("%l:%M %p"))

    expect(page).to have_content("Prev")
    expect(page).to have_content("First")
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
    @second_scheduled_message ||= create(:scheduled_message, title: 'Onboarding message 2')
  end
end
