require "rails_helper"

feature "Visit root path" do
  scenario "sees messages index" do
    message = create(:scheduled_message)
    login_with_oauth

    visit root_path

    expect(page).to have_content(message.title)
  end
end
