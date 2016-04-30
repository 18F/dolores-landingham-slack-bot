class TestMessagesController < ApplicationController
  def new
    @message = ScheduledMessage.find(params[:scheduled_message_id])
  end

  def create
    message = ScheduledMessage.find(params[:scheduled_message_id])
    employee = Employee.find_by(slack_username: slack_username)

    if !employee.slack_channel_id.nil? || !employee.slack_user_id.nil?
      MessageSender.new(employee, message).delay.run
      flash[:notice] = "Test message sent successfully"
      redirect_to scheduled_messages_path
    elsif employee.slack_channel_id.nil? || employee.slack_user_id.nil?
      flash[:error] = "Oops! Looks like this employees information isn't up to date. Check to make sure they haven't changed their slackname!"
      redirect_to scheduled_messages_path
    else
      flash[:error] = "Oops! Looks like that employee isn't in the Dolores system yet! Make sure you've entered the Slack handle (#{slack_username}) for the employee before sending him/her/them a test message."
      redirect_to scheduled_messages_path
    end
  end

  private

  def slack_username
    params[:test_message][:slack_username]
  end

  def slack_user_id
    params[:test_message][:slack_user_id]
  end

end
