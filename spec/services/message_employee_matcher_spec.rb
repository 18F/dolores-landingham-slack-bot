require "rails_helper"

describe MessageEmployeeMatcher do
  describe "#run" do
    it "matches messages to users based on days after start" do
      Timecop.freeze(Time.current) do
        days_after_start = 3
        scheduled_message = create(:scheduled_message, days_after_start: days_after_start, time_of_day: Time.current.in_time_zone("Eastern Time (US & Canada)"))
        employee = create(:employee, started_on: days_after_start.days.ago)

        matched_employees_and_messages = MessageEmployeeMatcher.new(scheduled_message).run

        expect(matched_employees_and_messages).to eq(
            [ employee ]
        )
      end
    end

    it "matches messages to users if the user's time has advanced past the scheduled message send at time but hasn't been sent yet" do
      Timecop.freeze(Time.current) do
        days_after_start = 3
        half_hour_time_difference_in_seconds = 1800
        scheduled_message_time = Time.current.in_time_zone("Eastern Time (US & Canada)")
        scheduled_message_time = scheduled_message_time - half_hour_time_difference_in_seconds
        scheduled_message = create(:scheduled_message, days_after_start: days_after_start, time_of_day: scheduled_message_time)
        employee = create(:employee, started_on: days_after_start.days.ago)

        matched_employees_and_messages = MessageEmployeeMatcher.new(scheduled_message).run

        expect(matched_employees_and_messages).to eq(
            [ employee ]
        )
      end
    end

    it "ignores messages that have already been sent to users" do
      Timecop.freeze(Time.current) do
        days_after_start = 3
        scheduled_message = create(:scheduled_message, days_after_start: days_after_start, time_of_day: Time.current.in_time_zone("Eastern Time (US & Canada)"))
        employee_one = create(:employee, started_on: days_after_start.days.ago)
        employee_two = create(:employee, started_on: days_after_start.days.ago)
        client_double = Slack::Web::Client.new
        slack_channel_id = "fake_slack_channel_id"
        slack_channel_finder_double = double(run: slack_channel_id)

        allow(Slack::Web::Client).to receive(:new).and_return(client_double)
        allow(SlackChannelIdFinder).
          to receive(:new).with(employee_one.slack_username, client_double).
          and_return(slack_channel_finder_double)

        pre_matched_employees_and_messages = MessageEmployeeMatcher.new(scheduled_message).run
        MessageSender.new(employee_one, scheduled_message).run
        post_matched_employees_and_messages = MessageEmployeeMatcher.new(scheduled_message).run

        expect(pre_matched_employees_and_messages).to eq(
            [ employee_one, employee_two ]
        )
        expect(post_matched_employees_and_messages).to eq(
            [ employee_two ]
        )
      end
    end
  end
end
