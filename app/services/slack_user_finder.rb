class SlackUserFinder < SlackApiWrapper
  def existing_user?
    !slack_user.nil?
  end

  def users_list
    all_slack_users
  end
end
