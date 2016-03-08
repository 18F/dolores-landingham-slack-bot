require "rails_helper"

describe Employee do
  describe "Associations" do
    it { should have_many(:sent_scheduled_messages).dependent(:destroy) }
  end

  describe "Validations" do
     subject { build(:employee) }
     it { should validate_presence_of(:slack_username) }
     it { should validate_uniqueness_of(:slack_username) }
     it { should allow_value("test_user_1").for(:slack_username) }
     it { should_not allow_value("TEST USER 1").for(:slack_username) }
     it { should_not allow_value("@test_user_1").for(:slack_username) }
     it { should validate_presence_of(:started_on) }
     it { should validate_presence_of(:time_zone) }
  end

  describe "#validate_slack_username_in_org" do
    it "returns true if slack username is in org" do
      username_from_fixture = "testusername"
      employee = build(:employee, slack_username: username_from_fixture)


      employee.validate_slack_username_in_org

      expect(employee.errors.size).to eq 0
    end

    it "adds error if slack username is not in org" do
      employee = build(:employee, slack_username: "not_in_org")


      employee.validate_slack_username_in_org

      expect(employee.errors.size).to eq 1
    end
  end
end
