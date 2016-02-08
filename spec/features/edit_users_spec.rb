require "rails_helper"

feature "Edit user" do
  context "current user is an admin" do
    scenario "can make other users admins" do
      admin = create(:admin)
      user = create(:user)
      login_with_oauth(admin)

      visit edit_user_path(user)

      check "Admin"
      click_on "Update User"

      expect(page).to have_content("User updated successfully")
    end
  end

  context "current user is not an admin" do
    scenario "cannot edit users" do
      user = create(:user)
      login_with_oauth(user)

      visit edit_user_path(user)

      expect(page).to have_content("You are not permitted to view that page")
    end
  end
end
