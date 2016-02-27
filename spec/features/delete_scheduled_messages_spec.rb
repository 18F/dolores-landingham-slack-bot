require "rails_helper"

feature "Delete scheduled messages" do
  context "admin user" do
    scenario "from list of scheduled messages", :js do
      admin = create(:admin)
      message = create(:scheduled_message)

      login_with_oauth(admin)
      visit scheduled_messages_path
      click_accept_on_javascript_popup do
        page.find(".button-delete").click
      end

      expect(page).to have_content("You deleted #{message.title}")
    end
  end

  context "non-admin user" do
    scenario "does not see link to destroy scheduled messages", :js do
      user = create(:user)
      message = create(:scheduled_message)

      login_with_oauth(user)
      visit scheduled_messages_path

      expect(page).not_to have_content("Delete")
    end
  end
end
