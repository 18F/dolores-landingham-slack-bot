require "rails_helper"

describe OnboardingMessage do
  describe "Associations" do
    it { should have_many(:sent_messages).dependent(:destroy) }
  end

  describe "Validations" do
     it { should validate_presence_of(:body) }
     it { should validate_presence_of(:days_after_start) }
     it { should validate_presence_of(:tag_list) }
     it { should validate_presence_of(:time_of_day) }
     it { should validate_presence_of(:title) }
  end

  describe '.date_time_ordering' do
    it 'should display the messages in chronological order' do
      m5 = create(:onboarding_message, days_after_start: 4, time_of_day: '2000-01-01 11:00:00 UTC')
      m2 = create(:onboarding_message, time_of_day: '2000-01-01 16:00:00 UTC')
      m1 = create(:onboarding_message, days_after_start: 1, time_of_day: '2000-01-01 11:00:00 UTC')
      m4 = create(:onboarding_message, time_of_day: '2000-01-01 11:00:00 UTC')
      m3 = create(:onboarding_message, time_of_day: '2000-01-01 14:00:00 UTC')
      expect(OnboardingMessage.date_time_ordering).to match_array([m1, m2, m3, m4, m5])
    end
  end

  describe '.active' do
    it 'should display messages which have no end date or have future end dates' do
      nil_end_date = create(:onboarding_message)
      _expired = create(:onboarding_message, end_date: Date.yesterday)
      future_end_date = create(:onboarding_message, end_date: Date.tomorrow)
      expect(OnboardingMessage.active).to match_array([nil_end_date, future_end_date])
    end
  end
end
