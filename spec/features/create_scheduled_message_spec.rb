require "rails_helper"

feature "Create scheduled message" do
  context "admin user" do
    scenario "can create a scheduled message" do
      admin = create(:admin)
      login_with_oauth(admin)
      visit root_path
      visit new_scheduled_message_path

      fill_in "Title", with: "Message title"
      fill_in "Message body", with: "Message body"
      fill_in "Business days after employee starts to send message", with: 1
      select "11 AM", from: "scheduled_message_time_of_day_4i"
      select "45", from: "scheduled_message_time_of_day_5i"
      fill_in "Tags", with: "tag_one, tag_two, tag_three"
      click_on "Create Scheduled message"

      expect(page).to have_content("Scheduled message created successfully")
    end

    scenario "unsuccessfully due to missing required fields" do
      admin = create(:admin)
      login_with_oauth(admin)
      visit root_path
      visit new_scheduled_message_path

      fill_in "Title", with: "Message title"
      fill_in "Business days after employee starts to send message", with: 1
      click_on "Create Scheduled message"

      expect(page).to have_content("Could not create scheduled message")
      expect(page).to have_content("can't be blank")
    end
  end

  context "non admin user" do
    scenario "does not see link to create a scheduled message" do
      user = create(:user)
      login_with_oauth(user)

      visit root_path

      expect(page).not_to have_content("Create scheduled message")
    end

    scenario "cannot view scheduled message form" do
      user = create(:user)
      login_with_oauth(user)

      visit new_scheduled_message_path

      expect(page).to have_content("You are not permitted to view that page")
    end
  end
end
