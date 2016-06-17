require "rails_helper"

describe NextWorkingDayFinder do

  it "returns the given day when it is a non-holiday weekday" do
    expect(NextWorkingDayFinder.run(non_holiday_monday)).to eq non_holiday_monday
  end

  it "returns the coming non holiday monday when it is a weekend day" do
    expect(NextWorkingDayFinder.run(saturday)).to eq saturday + 2.days
  end

  it "returns the nearest workday after a midweek holiday" do
    BusinessTime::Config.holidays << tues_nov_1_national_pet_your_cat_day

    expect(NextWorkingDayFinder.run(tues_nov_1_national_pet_your_cat_day)).
      to eq tues_nov_1_national_pet_your_cat_day + 1.days
  end


  def non_holiday_monday
    Date.parse('4-4-2016')
  end

  def saturday
    Date.parse('4-6-2016')
  end

  def tues_nov_1_national_pet_your_cat_day
    Date.parse('1-11-2016')
  end

end
