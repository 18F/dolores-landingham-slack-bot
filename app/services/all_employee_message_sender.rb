class AllEmployeeMessageSender
  def initialize(message)
    @message = message
  end

  def run
    Employee.find_each do |employee|
      MessageSender.new(employee, message).run
    end

    message.update(last_sent_at: Time.current)
  end

  private

  attr_reader :message
end
