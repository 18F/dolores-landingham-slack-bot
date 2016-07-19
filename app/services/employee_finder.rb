require "slack-ruby-client"

class EmployeeFinder
  def initialize(slack_username = '')
    @slack_username = slack_username
  end

  def existing_employee?
    SlackUserFinder.new(@slack_username, client).existing_user?
  end

  def slack_user_id
    SlackUserFinder.new(@slack_username, client).user_id
  end

  def users_list
    SlackUserFinder.new(@slack_username, client).users_list
  end

  private

  def client
    @client ||= Slack::Web::Client.new
  end
end
