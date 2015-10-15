require "rails_helper"

feature "Edit scheduled messages" do
  scenario "successfully" do
    old_title = "Old title"
    new_title = "New title"
    tags = "tag_one, tag_two, tag_three"
    create(:scheduled_message, title: old_title)

    login_with_oauth
    visit scheduled_messages_path
    click_on "Edit"
    fill_in "Title", with: new_title
    fill_in "Tags", with: tags
    click_on "Update Scheduled message"

    expect(page).to have_content "Scheduled message updated successfully"
    expect(page).to have_content new_title
    expect(page).to have_content "tag_one"
    expect(page).to have_content "tag_two"
    expect(page).to have_content "tag_three"
  end

  scenario "unsuccessfully due to missing required fields" do
    old_title = "Old title"
    new_title = "New title"
    tags = ""
    create(:scheduled_message, title: old_title)

    login_with_oauth
    visit scheduled_messages_path
    click_on "Edit"
    fill_in "Title", with: new_title
    fill_in "Tags", with: tags
    click_on "Update Scheduled message"

    expect(page).to have_content "Could not update scheduled message"
    expect(page).to have_content "can't be blank"
  end
end
