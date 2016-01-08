require 'holidays'

BusinessTime::Config.load("#{Rails.root}/config/business_time.yml")

Holidays.between(Date.civil(2013, 1, 1), 2.years.from_now, :us, :observed).map do |holiday|
  BusinessTime::Config.holidays << holiday[:date]
  # Implement long weekends if they apply to the region, eg:
  # BusinessTime::Config.holidays << holiday[:date].next_week if !holiday[:date].weekday?
end
