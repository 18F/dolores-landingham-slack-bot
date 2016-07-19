require "rails_helper"

describe SlackUsernameUpdater do
  describe "#update" do
    it "updates the employee's username when it has changed" do
      slack_user_id_from_fixture = "123ABC_ID"
      employee = create(
        :employee,
        slack_username: "oldname",
        slack_user_id: slack_user_id_from_fixture
      )

      SlackUsernameUpdater.new(employee).update

      expect(employee.reload.slack_username).to eq "testusername"
    end
  end
end
