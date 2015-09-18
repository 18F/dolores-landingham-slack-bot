FactoryGirl.define do
  factory :employee do
    slack_username "test_username_123"
    started_on  { Date.today }
  end

  factory :scheduled_message do
    title "Onboarding message 1"
    body "This is an awesome message!"
    days_after_start 3
  end
end
