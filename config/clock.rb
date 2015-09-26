require "clockwork"
require_relative "boot"
require_relative "environment"

module Clockwork
  every(1.day, "scheduled_messages.send", at: "19:30", tz: "UTC") do
    puts "Sending scheduled messages"
    DailyMessageSender.new.delay.run
  end
end
