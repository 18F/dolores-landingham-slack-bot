module OauthHelper
  def login_with_oauth(user = create(:user))
    setup_mock_auth(user.email)
    visit "/auth/githubteammember"
  end

  def setup_mock_auth(email = "test@example.com")
    OmniAuth.config.mock_auth[:githubteammember] =
      OmniAuth::AuthHash.new(
        credentials: {
          "team_member?" => true,
        },
        provider: "githubteammember",
        info: {
          name: "Doris Doogooder",
          email: email,
          nickname: "github_username",
          uid: "12345",
        },
    )
  end
end
