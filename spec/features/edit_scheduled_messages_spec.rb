require "rails_helper"

feature "Edit scheduled messages" do
  context "admin user" do
    scenario "successfully" do
      old_title = "Old title"
      new_title = "New title"
      tags = "tag_one, tag_two, tag_three"
      create(:scheduled_message, title: old_title)
      admin = create(:admin)

      login_with_oauth(admin)
      visit scheduled_messages_path
      page.find(".button-edit").click
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
      admin = create(:admin)

      login_with_oauth(admin)
      visit scheduled_messages_path
      page.find(".button-edit").click
      fill_in "Title", with: new_title
      fill_in "Tags", with: tags
      click_on "Update Scheduled message"

      expect(page).to have_content "Could not update scheduled message"
      expect(page).to have_content "can't be blank"
    end
  end

  context "non admin user" do
    scenario "does not see link to edit a scheduled message" do
      user = create(:user)
      create(:scheduled_message)
      login_with_oauth(user)

      visit scheduled_messages_path

      expect(page).not_to have_selector(".button-edit")
    end

    scenario "cannot visit edit path for a scheduled message" do
      scheduled_message = create(:scheduled_message)
      user = create(:user)
      login_with_oauth(user)

      visit edit_scheduled_message_path(scheduled_message)

      expect(page).to have_content("You are not permitted to view that page")
    end
  end
end
