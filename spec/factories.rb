FactoryGirl.define do
  factory :employee do
    slack_username "test_username_123"
    started_on  { Date.today }
  end
end
