require "business_time"

class OnboardingMessageEmployeeMatcher
  def initialize(message)
    @message = message
  end

  def run
    retrieve_employees_needing_onboarding_message
  end

  private

  attr_reader :message

  def retrieve_employees_needing_onboarding_message
    Employee.where(
      started_on: Range.new(
        day_count.business_days.ago - 1.day,
        day_count.business_days.ago + 1.day,
      ),
    ).select do |employee|
      time_to_send_message?(employee) &&
        onboarding_message_not_already_sent?(employee)
    end
  end

  def day_count
    message.days_after_start
  end

  def time_to_send_message?(employee)
    send_date_without_timezone = day_count.business_days.after(
      employee.started_on,
    )
    send_date_with_timezone = send_date_without_timezone.in_time_zone(
      employee.time_zone,
    )
    send_time = send_date_with_timezone.change(
      hour: message.time_of_day.hour,
      min: message.time_of_day.min,
    )
    Time.current >= send_time
  end

  def onboarding_message_not_already_sent?(employee)
    SentMessage.where(employee: employee, message: message).count == 0
  end
end
