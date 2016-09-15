require "rails_helper"

feature "Sign in user" do
  scenario "signing in a new user that is a member of the correct Github team" do
    setup_mock_auth("user@example.com")

    visit root_path
    click_link "Sign in with GitHub"

    expect(page).to have_content "You successfully signed in"
  end

  scenario "attempting to sign in a new user that is not a member of the Github team and encountering an error" do
    setup_mock_auth("user@example.com", team_member: false)

    visit root_path
    click_link "Sign in with GitHub"

    expect(page).to have_content "We were unable to authenticate your user profile"
  end

  scenario "signing in an existing user that is a member of the correct Github team" do
    user = create(:user)
    setup_mock_auth(user.email)

    visit root_path
    click_link "Sign in with GitHub"

    expect(page).to have_content "You successfully signed in"
  end

  scenario "signing in an existing user that has been removed from the correct Github team" do
    user = create(:user)
    setup_mock_auth(user.email, team_member: false)

    visit root_path
    click_link "Sign in with GitHub"

    expect(page).to have_content "We were unable to authenticate your user profile"
  end
end
