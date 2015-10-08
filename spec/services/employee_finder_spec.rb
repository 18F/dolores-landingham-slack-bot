require "rails_helper"

describe EmployeeFinder do
  describe "#employee_exists?" do
    it "returns true if an employee exists in the Slack organization associated with the auth token" do
      employee = create(:employee)
      client_double = Slack::Web::Client.new
      existing_user_double = double(existing_user?: true)

      allow(Slack::Web::Client).to receive(:new).and_return(client_double)
      allow(SlackUserFinder).
        to receive(:new).with(employee.slack_username, client_double).
        and_return(existing_user_double)

      employee_finder = EmployeeFinder.new(employee.slack_username)

      expect(employee_finder).to be_existing_employee
    end

    it "rreturns false if an employee does not exist in the Slack organization associated with the auth token" do
      employee = create(:employee)
      client_double = Slack::Web::Client.new
      existing_user_double = double(existing_user?: false)

      allow(Slack::Web::Client).to receive(:new).and_return(client_double)
      allow(SlackUserFinder).
        to receive(:new).with(employee.slack_username, client_double).
        and_return(existing_user_double)

      employee_finder = EmployeeFinder.new(employee.slack_username)

      expect(employee_finder).not_to be_existing_employee
    end
  end
end
