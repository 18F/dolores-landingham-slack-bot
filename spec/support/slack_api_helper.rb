module SlackApiHelper
  def mock_slack_channel_finder_for_employee(employee, options = {})
    slack_channel_id = options[:channel_id]
    client_double = Slack::Web::Client.new
    slack_channel_finder_double = double(run: slack_channel_id)

    allow(Slack::Web::Client).to receive(:new).and_return(client_double)
    allow(SlackChannelIdFinder).
      to receive(:new).with(employee.slack_user_id, client_double).
      and_return(slack_channel_finder_double)
  end
end
