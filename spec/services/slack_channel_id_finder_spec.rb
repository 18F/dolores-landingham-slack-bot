require "rails_helper"

describe SlackChannelIdFinder do
  describe "#run" do
    it "finds the slack user channel id if member of bot's org" do
      channel_id_from_fixture = "123ABC_IM_ID"
      slack_user_id_from_fixture = "123ABC_ID"

      channel_id = SlackChannelIdFinder.new(
        slack_user_id_from_fixture,
        Slack::Web::Client.new
      ).run

      expect(channel_id).to eq channel_id_from_fixture
    end

    it "does not error when user not found" do
      channel_id = SlackChannelIdFinder.new("not_found", Slack::Web::Client.new).run

      expect(channel_id).to be_nil
    end
  end
end
