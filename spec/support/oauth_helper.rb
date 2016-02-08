module OauthHelper
  def login_with_oauth(user = create(:user))
    setup_mock_auth(user.email)
    visit "/auth/myusa"
  end

  def setup_mock_auth(email)
    OmniAuth.config.mock_auth[:myusa] = OmniAuth::AuthHash.new(
      provider: "myusa",
      raw_info: {
        "name" => "George Jetson"
      },
      uid: "12345",
      nickname: "georgejetsonmyusa",
      extra: {
        "raw_info" => {
          "email" => email,
          "first_name" => "George",
          "last_name" => "Jetson"
        }
      },
      credentials: {
        "token" => "1a2b3c4d"
      }
    )
  end
end
