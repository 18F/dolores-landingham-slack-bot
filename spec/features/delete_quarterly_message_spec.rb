require "rails_helper"

feature "Delete quarterly messages" do
  context "admin user" do
    scenario "from list of quarterly messages", :js do
      admin = create(:admin)
      message = create(:quarterly_message)

      login_with_oauth(admin)
      visit quarterly_messages_path
      click_accept_on_javascript_popup do
        page.find(".button-delete").click
      end

      expect(page).to have_content("You deleted #{message.title}")
    end
  end

  context "non-admin user" do
    scenario "does not see link to destroy quarterly messages", :js do
      user = create(:user)
      message = create(:quarterly_message)

      login_with_oauth(user)
      visit quarterly_messages_path

      expect(page).not_to have_content("Delete")
    end
  end
end
