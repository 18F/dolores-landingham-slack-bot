class SlackUserImporter < SlackApiWrapper
  def slack_usernames
    all_slack_users.map { |slack_user| slack_user["name"] }
  end
end
