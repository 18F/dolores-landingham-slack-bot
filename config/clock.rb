require "clockwork"
require_relative "boot"
require_relative "environment"

module Clockwork
  every(1.minute, "scheduled_messages.send") do
    puts "Sending scheduled messages"
    DailyMessageSender.new.delay.run
  end
end
