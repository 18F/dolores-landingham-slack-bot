require "rails_helper"

feature "Create scheduled message" do
  scenario "successfully" do
    login_with_oauth
    visit root_path
    click_on "Create scheduled message"

    fill_in "Title", with: "Message title"
    fill_in "Message body", with: "Message body"
    fill_in "Days after employee starts to send message", with: 1
    fill_in "Tags", with: "tag_one, tag_two, tag_three"
    click_on "Create Scheduled message"

    expect(page).to have_content("Scheduled message created successfully")
  end

  scenario "unsuccessfully due to missing required fields" do
    login_with_oauth
    visit root_path
    click_on "Create scheduled message"

    fill_in "Title", with: "Message title"
    fill_in "Days after employee starts to send message", with: 1
    click_on "Create Scheduled message"

    expect(page).to have_content("Could not create scheduled message")
    expect(page).to have_content("can't be blank")
  end
end
