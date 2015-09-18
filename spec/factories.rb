FactoryGirl.define do
  sequence(:slack_username) { |n| "test_username_#{n}" }

  factory :employee do
    started_on  { Date.today }
    slack_username
  end

  factory :scheduled_message do
    title "Onboarding message 1"
    body "This is an awesome message!"
    days_after_start 3
  end
end
