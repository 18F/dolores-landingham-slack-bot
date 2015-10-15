require "rails_helper"

describe ScheduledMessage do
  describe "Validations" do
     it { should validate_presence_of(:body) }
     it { should validate_presence_of(:days_after_start) }
     it { should validate_presence_of(:tag_list) }
     it { should validate_presence_of(:title) }
  end
end
