class SlackUserFinder < SlackApiWrapper
  def existing_user?
    !slack_user.nil?
  end

  def user_id
    if slack_user.present?
      slack_user["id"]
    end
  end

  def username
    if slack_user_by_id.present?
      slack_user["name"]
    end
  end

  def users_list
    all_slack_users
  end
end
