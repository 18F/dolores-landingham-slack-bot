require "rails_helper"

describe QuarterlyMessage do
  describe "Associations" do
    it { should have_many(:sent_messages).dependent(:destroy) }
  end

  describe "Validations" do
     it { should validate_presence_of(:body) }
     it { should validate_presence_of(:tag_list) }
     it { should validate_presence_of(:title) }
  end
end
