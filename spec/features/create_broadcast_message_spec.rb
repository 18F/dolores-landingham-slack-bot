require "rails_helper"

feature "Create broadcast message" do
  scenario "successfully" do
    login_with_oauth(create(:admin))

    visit new_broadcast_message_path
    fill_in "Title", with: "Message title"
    fill_in "Message body", with: "Message body"
    click_on "Create Broadcast message"

    expect(page).to have_content "Broadcast message created successfully"
    expect(page).to have_content "Message title"
    expect(page).to have_content "Message body"
  end
end
