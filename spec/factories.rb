FactoryGirl.define do
  sequence(:slack_username) { |n| "test_username_#{n}" }

  factory :employee do
    started_on  { Date.today }
    slack_username
  end

  factory :sent_scheduled_message do
    employee
    scheduled_message
    message_body "Message body!"
    sent_on { Date.today }
  end

  factory :scheduled_message do
    title "Onboarding message 1"
    body "This is an awesome message!"
    days_after_start 3
    tag_list "test_tag, test_tag_two"
  end
end
