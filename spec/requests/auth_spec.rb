require "rails_helper"
require "support/oauth_helper"
include OauthHelper

describe "Auth request" do
  it "creates a new user if a user for the email address does not exist" do
    email = "test@example.com"
    setup_mock_auth(email)

    get "/auth/myusa/callback"

    expect(User.count).to eq 1
    expect(User.last.email).to eq email
  end

  it "does not create a user if a user for the email address does exist" do
    user = create(:user)
    setup_mock_auth(user.email)

    get "/auth/myusa/callback"

    expect(User.count).to eq 1
    expect(User.last).to eq user
  end

  it "redirects user to root path if user email address is not permitted" do
    allow(ENV).to receive(:[]).with("AUTH_DOMAIN").and_return("gsa.gov")
    setup_mock_auth("test@example.com")

    get "/auth/myusa/callback",
      nil,
      { "HTTP_REFERER" => "https://alpha.my.usa.gov/users/sign_in" }

    expect(User.count).to eq 0
    expect(response).to redirect_to("https://alpha.my.usa.gov/users/sign_in")
  end
end
