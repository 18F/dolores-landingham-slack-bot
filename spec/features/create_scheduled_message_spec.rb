require "rails_helper"

feature "Create scheduled message" do
  scenario "successfully" do
    login_with_oauth
    visit root_path
    click_on "Create scheduled message"

    fill_in "Title", with: "Message title"
    fill_in "Message body", with: "Message body"
    fill_in "Days after employee starts to send message", with: 1
    click_on "Create Scheduled message"

    expect(page).to have_content("Scheduled message created successfully")
  end
end
