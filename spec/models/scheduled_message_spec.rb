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
     it 'should not validate days_after_start if message_time_frame is quarterly' do
       quarterly_scheduled_message = build(:scheduled_message, 
                                           days_after_start: nil, message_time_frame: :quarterly)

       expect(quarterly_scheduled_message).to be_valid
     end
  end

  describe '.date_time_ordering' do
    it 'should display the messages in chronological order' do
      m1 = create(:scheduled_message, days_after_start: 1, time_of_day: '2000-01-01 11:00:00 UTC')
      m2 = create(:scheduled_message, time_of_day: '2000-01-01 16:00:00 UTC')
      m3 = create(:scheduled_message, time_of_day: '2000-01-01 14:00:00 UTC')
      m4 = create(:scheduled_message, time_of_day: '2000-01-01 11:00:00 UTC')
      m5 = create(:scheduled_message, days_after_start: 4, time_of_day: '2000-01-01 11:00:00 UTC')
      expect(ScheduledMessage.date_time_ordering).to match_array([m1, m2, m3, m4, m5])
    end
  end

  describe '.active' do
    it 'should display messages which have no end date or have future end dates' do
      ScheduledMessage.destroy_all
      nil_end_date = create(:scheduled_message)
      expired = create(:scheduled_message, end_date: Date.yesterday)
      future_end_date = create(:scheduled_message, end_date: Date.tomorrow)
      expect(ScheduledMessage.active).to match_array([nil_end_date, future_end_date])
    end
  end

  describe '.quarterly' do
    it 'should display messages with the "quarterly" message_time_frame' do
      ScheduledMessage.destroy_all
      onboarding_message = create(:scheduled_message, message_time_frame: :onboarding)
      quarterly_message = create(:scheduled_message, message_time_frame: :quarterly)

      expect(ScheduledMessage.quarterly).to match_array([quarterly_message])
    end
  end
end
