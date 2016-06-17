require 'business_time'

class NextWorkingDayFinder
  attr_reader :date

  def self.run(date = Time.today)
    new(date).run
  end

  def initialize(date = Time.today)
    @date = date
  end

  def run
    @date += 1.day until @date.workday?
    @date
  end
end
