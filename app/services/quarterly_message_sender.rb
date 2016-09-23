class QuarterlyMessageSender
  def run
    QuarterlyMessage.all.each do |message|
      employees_for_message = find_employees(message)

      employees_for_message.each do |employee|
        MessageSender.new(employee, message).run
      end
    end
  end

  private

  def find_employees(message)
    QuarterlyMessageEmployeeMatcher.new(message).run
  end
end
