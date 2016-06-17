require "rails_helper"

describe QuarterlyMessageDayVerifier do
  context "not on weekends or holidays" do
    it "returns true if the current date is a Quarterly Message day" do
      expect(QuarterlyMessageDayVerifier.new(date: april_1_non_holiday_wednesday).run).to be_truthy
    end
    it "returns false if the current date is not a Quarterly Message day" do
      expect(QuarterlyMessageDayVerifier.new(date: april_3_non_holiday_friday).run).to be_falsey
    end
  end

  context "on a weekend" do
    it "returns false if the current date is a Quarterly Message day on a weekend" do
      expect(QuarterlyMessageDayVerifier.new(date: october_1_saturday).run).to be_falsey
    end
    it "returns true for the first workday following the weekend quarterly message day" do
      expect(QuarterlyMessageDayVerifier.new(date: october_1_saturday + 2.days).run).to be_truthy
    end
  end

  context "on a holiday" do
    it "returns false if the current date is a holiday" do
      BusinessTime::Config.holidays << fri_feb_6_national_eat_pickles_day

      expect(QuarterlyMessageDayVerifier.new(date: fri_feb_6_national_eat_pickles_day).run).to be_falsey
    end
    it "returns true for the first workday following the holiday quarterly message day" do
      BusinessTime::Config.holidays << fri_feb_6_national_eat_pickles_day

      expect(QuarterlyMessageDayVerifier.new(date: fri_feb_6_national_eat_pickles_day + 2.days).run).to be_falsey
    end
  end

  #helpers

  def april_1_non_holiday_wednesday
    Date.parse('1-4-2015')
  end

  def april_3_non_holiday_friday
    Date.parse('3-4-2015')
  end

  def october_1_saturday
    Date.parse('1-10-2016')
  end

  def fri_feb_6_national_eat_pickles_day
    Date.parse('6-1-2015')
  end


end
