require "rails_helper"

feature "Visit root path" do
  scenario "sees messages index" do
    message = create(:scheduled_message)
    login_with_oauth

    visit root_path

    expect(page).to have_content(message.title)
  end

  scenario "roots to sessions#new when not logged in" do
    visit root_path

    expect(page).to have_content("Sign in with GitHub")
  end
end
