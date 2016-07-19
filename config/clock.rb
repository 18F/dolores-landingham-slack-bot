require "clockwork"
require_relative "boot"
require_relative "environment"

module Clockwork
  every(1.minute, "scheduled_messages.send") do
    puts "Sending scheduled messages"
    DailyMessageSender.new.delay.run
  end

  every(1.day, "employees.import", at: "03:00", tz: "UTC") do
    puts "Importing new employees"
    EmployeeImporter.new.delay.run
  end

  every(1.day, "employees.update", at: "03:00", tz: "UTC") do
    puts "Updating employee slack usernames"
    EmployeeUpdater.new.delay.run
  end
end
