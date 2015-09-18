require "rails_helper"

describe Employee do
  describe "Validations" do
     subject { create(:employee) }
     it { should validate_presence_of(:slack_username) }
     it { should validate_uniqueness_of(:slack_username) }
     it { should validate_presence_of(:started_on) }
  end
end
