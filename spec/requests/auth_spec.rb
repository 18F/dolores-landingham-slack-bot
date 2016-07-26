require "rails_helper"
require "support/oauth_helper"
include OauthHelper

describe "Auth request" do
  it "creates a new user if a user for the email address does not exist" do
    email = "test@example.com"
    setup_mock_auth(email)

    get "/auth/githubteammember/callback"

    expect(User.count).to eq 1
    expect(User.last.email).to eq email
  end

  it "does not create a user if a user for the email address does exist" do
    user = create(:user)
    setup_mock_auth(user.email)

    get "/auth/githubteammember/callback"

    expect(User.count).to eq 1
    expect(User.last).to eq user
  end
end
