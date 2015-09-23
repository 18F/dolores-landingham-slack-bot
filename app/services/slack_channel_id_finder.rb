class SlackChannelIdFinder
  def initialize(slack_username, client)
    @slack_username = slack_username
    @client = client
  end

  def run
    if slack_user
      slack_user_id = slack_user["id"]
      chat = client.im_open(user: slack_user_id)
      chat["channel"]["id"]
    end
  end

  private

  attr_accessor :client, :slack_username

  def slack_user
    @slack_user ||= all_slack_users.find do |user_data|
      user_data["name"] == slack_username
    end
  end

  def all_slack_users
    client.users_list["members"]
  end
end
