require "rails_helper"

feature "Edit onboarding messages" do
  context "admin user" do
    scenario "successfully" do
      old_title = "Old title"
      new_title = "New title"
      tags = "tag_one, tag_two, tag_three"
      create(:onboarding_message, title: old_title)
      admin = create(:admin)

      login_with_oauth(admin)
      visit onboarding_messages_path
      page.find(".button-edit").click
      fill_in "Title", with: new_title
      fill_in "Tags", with: tags
      click_on "Update Onboarding message"

      expect(page).to have_content "Onboarding message updated successfully"
      expect(page).to have_content new_title
      expect(page).to have_content "tag_one"
      expect(page).to have_content "tag_two"
      expect(page).to have_content "tag_three"
    end

    scenario "unsuccessfully due to missing required fields" do
      old_title = "Old title"
      new_title = "New title"
      tags = ""
      create(:onboarding_message, title: old_title)
      admin = create(:admin)

      login_with_oauth(admin)
      visit onboarding_messages_path
      page.find(".button-edit").click
      fill_in "Title", with: new_title
      fill_in "Tags", with: tags
      click_on "Update Onboarding message"

      expect(page).to have_content "Could not update onboarding message"
      expect(page).to have_content "can't be blank"
    end
  end

  context "non admin user" do
    scenario "does not see link to edit an onboarding message" do
      user = create(:user)
      create(:onboarding_message)
      login_with_oauth(user)

      visit onboarding_messages_path

      expect(page).not_to have_selector(".button-edit")
    end

    scenario "cannot visit edit path for a onboarding message" do
      onboarding_message = create(:onboarding_message)
      user = create(:user)
      login_with_oauth(user)

      visit edit_onboarding_message_path(onboarding_message)

      expect(page).to have_content("You are not permitted to view that page")
    end
  end
end
