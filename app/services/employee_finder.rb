require "slack-ruby-client"

class EmployeeFinder
  def initialize(slack_username = '')
    @slack_username = slack_username
  end

  def existing_employee?
    slack_user_finder.existing_user?
  end

  def slack_user_id
    slack_user_finder.user_id
  end

  def users_list
    @_users_list ||= slack_user_finder.users_list
  end

  private

  attr_reader :slack_username

  def slack_user_finder
    @_slack_user_finder ||= SlackUserFinder.new(slack_username, client)
  end

  def client
    @client ||= Slack::Web::Client.new
  end
end
