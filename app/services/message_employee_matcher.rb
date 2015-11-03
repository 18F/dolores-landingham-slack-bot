class MessageEmployeeMatcher
  def initialize(message)
    @message = message
  end

  def run
    retrieve_matching_employees
  end

  private

  attr_reader :message

  def retrieve_matching_employees
    Employee.where(started_on: day_count.days.ago)
      .select { |employee| match_time(employee.time_zone) && message_not_already_sent?(employee) }
  end

  def day_count
    message.days_after_start
  end

  def match_time(time_zone)
    employee_current_hour = Time.current.in_time_zone(time_zone).hour
    employee_current_minute = Time.current.in_time_zone(time_zone).min

    employee_current_hour == message.time_of_day.hour && employee_current_minute == message.time_of_day.min
  end

  def message_not_already_sent?(employee)
    SentScheduledMessage.where(employee: employee, scheduled_message: message).count == 0
  end
end
