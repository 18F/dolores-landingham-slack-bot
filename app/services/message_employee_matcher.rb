class MessageEmployeeMatcher
  def initialize(message)
    @message = message
  end

  def run
    Employee.where(started_on: day_count.days.ago)
  end

  private

  attr_reader :message

  def day_count
    message.days_after_start
  end
end
