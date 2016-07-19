class SlackUsernameUpdater < SlackApiWrapper
  def initialize(employee)
    @employee = employee
  end

  def update
    slack_username = SlackUserFinder.new(
      employee.slack_user_id,
      client,
    ).username

    if employee.slack_username != slack_username
      employee.update(slack_username: slack_username)
    end
  end

  private

  attr_reader :employee

  def client
    @client ||= Slack::Web::Client.new
  end
end
