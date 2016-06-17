require 'business_time'

class QuarterlyMessageDayVerifier
  attr_reader :date, :current_year

  DEFAULT_MONTH_DAYS_TO_SEND_ON = [[1, 1], [4, 1], [10, 1], [7, 1]].freeze

  def initialize(date: Time.today)
    @date = date
    @current_year = @date.year
  end

  def run
    quarterly_message_day?
  end

  private

  def quarterly_message_day?
    this_years_quarterly_message_days_pushed_to_workdays.any? do |quarter_date|
      @date.month == quarter_date.month && @date.day == quarter_date.day
    end
  end

  def this_years_unadjusted_quarterly_message_days
    DEFAULT_MONTH_DAYS_TO_SEND_ON.map do |month_day|
      Date.new(@current_year, month_day.first, month_day.last)
    end
  end

  def this_years_quarterly_message_days_pushed_to_workdays
    this_years_unadjusted_quarterly_message_days.map do |date|
      NextWorkingDayFinder.run(date)
    end
  end
end
