require "rails_helper"

feature "Delete onboarding messages" do
  context "admin user" do
    scenario "from list of onboarding messages", :js do
      admin = create(:admin)
      message = create(:onboarding_message)

      login_with_oauth(admin)
      visit onboarding_messages_path
      click_accept_on_javascript_popup do
        page.find(".button-delete").click
      end

      expect(page).to have_content("You deleted #{message.title}")
    end
  end

  context "non-admin user" do
    scenario "does not see link to destroy onboarding messages", :js do
      user = create(:user)
      message = create(:onboarding_message)

      login_with_oauth(user)
      visit onboarding_messages_path

      expect(page).not_to have_content("Delete")
    end
  end
end
