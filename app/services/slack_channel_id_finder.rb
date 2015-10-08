class SlackChannelIdFinder < SlackApiWrapper
  def run
    if slack_user
      slack_user_id = slack_user["id"]
      chat = client.im_open(user: slack_user_id)
      chat["channel"]["id"]
    end
  end
end
