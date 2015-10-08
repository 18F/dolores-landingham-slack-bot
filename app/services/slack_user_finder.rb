class SlackUserFinder < SlackApiWrapper
  def existing_user?
    !slack_user.nil?
  end
end
