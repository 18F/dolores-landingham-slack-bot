require "rails_helper"
require "business_time"

describe MessageEmployeeMatcher do
  describe "#run" do
    context "onboarding messages (sent days after start)" do
      it "matches messages to users based on days after start" do
        Timecop.freeze(Time.parse("11:00:00 UTC")) do
          days_after_start = 3
          employee_time_zone = "Eastern Time (US & Canada)"
          current_time_for_employee = Time.current.in_time_zone(employee_time_zone)
          current_time_et_as_utc = Time.zone.utc_to_local(current_time_for_employee)
          scheduled_message = create(
            :scheduled_message,
            days_after_start: days_after_start,
            time_of_day: current_time_et_as_utc)
          employee_one = create(:employee, started_on: days_after_start.business_days.ago)
          _employee_two = create(:employee, started_on: 5.business_days.ago)

          matched_employees_and_messages = MessageEmployeeMatcher.new(scheduled_message).run

          expect(matched_employees_and_messages).to eq(
              [employee_one]
          )
        end
      end

      context "midnight UTC" do
        it "does not send messages to employees who are at a later time but on a different date" do
          Timecop.freeze(Time.parse("00:00:00 UTC")) do
            days_after_start = 3
            scheduled_message_time = Time.parse("12:00:00 UTC")
            scheduled_message = create(:scheduled_message, days_after_start: days_after_start, time_of_day: scheduled_message_time)

            _employee_cst = create(:employee, started_on: days_after_start.business_days.ago, time_zone: "Central Time (US & Canada)")

            matched_employees_and_messages = MessageEmployeeMatcher.new(scheduled_message).run

            expect(matched_employees_and_messages).to eq([])
          end
        end
      end

      it "matches messages to users if the user's time has advanced past the scheduled message send at time but hasn't been sent yet" do
        Timecop.travel(2016, 2, 1) do
          Timecop.freeze(Time.parse("18:30:00 UTC")) do
            days_after_start = 3
            scheduled_message_time = Time.parse("12:00:00 UTC")
            scheduled_message = create(:scheduled_message, days_after_start: days_after_start, time_of_day: scheduled_message_time)
            employee_est = create(:employee, started_on: days_after_start.business_days.ago)
            employee_cst = create(:employee, started_on: days_after_start.business_days.ago, time_zone: "Central Time (US & Canada)")
            _employee_mst = create(:employee, started_on: days_after_start.business_days.ago, time_zone: "Mountain Time (US & Canada)")
            _employee_pst = create(:employee, started_on: days_after_start.business_days.ago, time_zone: "Pacific Time (US & Canada)")

            matched_employees_and_messages = MessageEmployeeMatcher.new(scheduled_message).run

            expect(matched_employees_and_messages).to eq(
              [employee_est, employee_cst]
            )
          end
        end
      end

      it "ignores messages whose send at time has not come to pass yet based on a user's local time" do
        Timecop.freeze(Time.parse("11:00:00 UTC")) do
          days_after_start = 3
          scheduled_message_time = Time.parse("12:00:00 UTC")
          scheduled_message = create(:scheduled_message, days_after_start: days_after_start, time_of_day: scheduled_message_time)
          _employee_est = create(:employee, started_on: days_after_start.business_days.ago)
          _employee_cst = create(:employee, started_on: days_after_start.business_days.ago, time_zone: "Central Time (US & Canada)")
          _employee_mst = create(:employee, started_on: days_after_start.business_days.ago, time_zone: "Mountain Time (US & Canada)")
          _employee_pst = create(:employee, started_on: days_after_start.business_days.ago, time_zone: "Pacific Time (US & Canada)")

          matched_employees_and_messages = MessageEmployeeMatcher.new(scheduled_message).run

          expect(matched_employees_and_messages).to eq([])
        end
      end

      it "ignores messages that have already been sent to users" do
        Timecop.freeze(Time.parse("11:00:00 UTC")) do
          days_after_start = 3
          employee_time_zone = "Eastern Time (US & Canada)"
          current_time_for_employee = Time.current.in_time_zone(employee_time_zone)
          current_time_et_as_utc = Time.zone.utc_to_local(current_time_for_employee)
          scheduled_message = create(
            :scheduled_message,
            days_after_start: days_after_start,
            time_of_day: current_time_et_as_utc
          )
          employee_one = create(:employee, started_on: days_after_start.business_days.ago)
          employee_two = create(:employee, started_on: days_after_start.business_days.ago)
          client_double = Slack::Web::Client.new
          slack_channel_id = "fake_slack_channel_id"
          slack_channel_finder_double = double(run: slack_channel_id)

          allow(Slack::Web::Client).to receive(:new).and_return(client_double)
          allow(SlackChannelIdFinder).
            to receive(:new).with(employee_one.slack_user_id, client_double).
            and_return(slack_channel_finder_double)

          pre_matched_employees_and_messages = MessageEmployeeMatcher.new(scheduled_message).run
          MessageSender.new(employee_one, scheduled_message).run
          post_matched_employees_and_messages = MessageEmployeeMatcher.new(scheduled_message).run

          expect(pre_matched_employees_and_messages).to eq(
            [employee_one, employee_two]
          )
          expect(post_matched_employees_and_messages).to eq(
            [employee_two]
          )
        end
      end
    end
  end
end
