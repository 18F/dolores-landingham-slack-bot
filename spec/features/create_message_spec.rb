require "rails_helper"

feature "Create message" do
  scenario "successfully" do
    login_with_oauth(create(:admin))

    visit new_message_path
    fill_in "Title", with: "Message title"
    fill_in "Message body", with: "Message body"
    click_on "Create Message"

    expect(page).to have_content "Message created successfully"
    expect(page).to have_content "Message title"
    expect(page).to have_content "Message body"
  end
end
