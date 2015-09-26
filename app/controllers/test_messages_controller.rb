class TestMessagesController < ApplicationController
  def new
    @message = ScheduledMessage.find(params[:scheduled_message_id])
  end

  def create
    message = ScheduledMessage.find(params[:scheduled_message_id])
    employee = Employee.find_by(slack_username: slack_username)

    if employee
      MessageSender.new(employee, message).delay.run
      flash[:notice] = "Test message sent successfully"
      redirect_to scheduled_messages_path
    else
      flash[:error] = "Could not update employee with the Slack username you entered. Please make sure there is an employee record for the username listed in #{employees_path}"
      redirect_to scheduled_messages_path
    end
  end

  private

  def slack_username
    params[:test_message][:slack_username]
  end
end
