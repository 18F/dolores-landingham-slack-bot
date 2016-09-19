class BroadcastMessageSender
  def initialize(broadcast_message)
    @broadcast_message = broadcast_message
  end

  def run
    Employee.find_each do |employee|
      MessageSender.new(employee, broadcast_message).delay.run
    end

    broadcast_message.update(last_sent_at: Time.current)
  end

  private

  attr_reader :broadcast_message
end
