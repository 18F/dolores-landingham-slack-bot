require "rails_helper"

describe ScheduledMessage do
  describe "Associations" do
    it { should have_many(:sent_scheduled_messages).dependent(:destroy) }
  end

  describe "Validations" do
     it { should validate_presence_of(:body) }
     it { should validate_presence_of(:days_after_start) }
     it { should validate_presence_of(:tag_list) }
     it { should validate_presence_of(:time_of_day) }
     it { should validate_presence_of(:title) }
  end
end
