require "rails_helper"

feature "Edit scheduled messages" do
  scenario "from list of scheduled messages" do
    old_title = "Old title"
    new_title = "New title"
    create(:scheduled_message, title: old_title)

    visit scheduled_messages_path
    click_on "Edit"
    fill_in "Title",with: new_title
    click_on "Update Scheduled message"

    expect(page).to have_content new_title
  end
end
