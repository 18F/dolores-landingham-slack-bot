require "rails_helper"

describe Employee do
  describe "Validations" do
     subject { create(:employee) }
     it { should validate_presence_of(:slack_username) }
     it { should validate_uniqueness_of(:slack_username) }
     it { should allow_value("test_user_1").for(:slack_username) }
     it { should_not allow_value("TEST USER 1").for(:slack_username) }
     it { should validate_presence_of(:started_on) }
  end
end
