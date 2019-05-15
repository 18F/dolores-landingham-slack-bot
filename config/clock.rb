require "clockwork"
require_relative "boot"
require_relative "environment"

module Clockwork
  every(1.minute, "onboarding_messages.send") do
    puts "Sending onboarding messages"
    OnboardingMessageSender.new.delay.run
  end

  # every(1.hour, "quarterly_messages.send") do
  #   puts "Sending quarterly messages"
  #   QuarterlyMessageSender.new.delay.run
  # end

  every(1.day, "employees.update", at: "03:00", tz: "UTC") do
    puts "Updating employee slack usernames"
    EmployeeUpdater.new.delay.run
  end
end
