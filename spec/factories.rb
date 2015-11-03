FactoryGirl.define do
  sequence(:slack_username) { |n| "test_username_#{n}" }

  factory :employee do
    slack_username
    started_on  { Date.today }
    time_zone "Eastern Time (US & Canada)"
  end

  factory :sent_scheduled_message do
    employee
    scheduled_message
    message_body "Message body!"
    sent_on { Date.today }
    sent_at { Time.parse("10:00:00 UTC") }
  end

  factory :scheduled_message do
    title "Onboarding message 1"
    body "This is an awesome message!"
    days_after_start 3
    time_of_day { Time.parse("10:00:00 UTC") }
    tag_list "test_tag, test_tag_two"
  end
end
