require "rails_helper"

describe SlackUserImporter do
  describe "#slack_usernames" do
    it "returns an array of all Slack usernames" do
      expected_slack_usernames = [
        "testusername",
        "testusername2",
        "testusername3",
        "u2",
      ]

      slack_usernames = SlackUserImporter.new("", Slack::Web::Client.new).slack_usernames

      expect(slack_usernames).to match_array(expected_slack_usernames)
    end
  end
end
