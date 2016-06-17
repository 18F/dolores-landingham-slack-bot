require 'business_time'

class QuarterlyMessageEmployeeMatcher
  TIME_OF_DAY_TO_SEND = 900

  def initialize(message)
    @message = message
  end

  def run
    if right_day_to_send_message?
      employees_needing_a_quarterly_message
    else
      []
    end
  end

  private

  def employees_needing_a_quarterly_message
    Employee.all.select do |employee|
      quarterly_message_not_already_sent?(employee) &&
        time_to_send_message?(employee.time_zone)
    end
  end

  def right_day_to_send_message?
    QuarterlyMessageDayVerifier.new(date: Time.now).run
  end

  def quarterly_message_not_already_sent?(employee)
    SentScheduledMessage
      .by_year(current_year)
      .where('sent_on > ?', 1.week.ago)
      .where(employee: employee, scheduled_message: @message).count == 0
  end

  def time_to_send_message?(time_zone)
    employee_current_time = Time.current.in_time_zone(time_zone)
    employee_current_time_value = employee_current_time.strftime('%H%M').to_i
    message_time_value = TIME_OF_DAY_TO_SEND
    employee_current_time_value >= message_time_value
  end

  def current_year
    Time.now.year
  end
end
