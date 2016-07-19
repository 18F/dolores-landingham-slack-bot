class EmployeeUpdater
  def run
    Employee.find_each do |employee|
      SlackUsernameUpdater.new(employee).update
    end
  end
end
