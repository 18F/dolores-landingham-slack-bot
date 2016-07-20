class TestMessagesController < ApplicationController
  def new
    if params[:scheduled_message_id]
      @message = ScheduledMessage.find(params[:scheduled_message_id])
      @url = scheduled_message_test_messages_path(@message)
    else
      @message = Message.find(params[:message_id])
      @url = message_test_messages_path(@message)
    end
  end

  def create
    employee = Employee.find_by(slack_username: slack_username)

    if employee && (employee.slack_channel_id || employee.slack_user_id)
      MessageSender.new(employee, message).delay.run
      flash[:notice] = "Test message sent successfully"
    elsif employee.nil?
      flash[:error] = "Oops! Looks like that employee isn't in the Dolores system yet! Make sure you've entered the Slack handle (#{slack_username}) for the employee before sending him/her/them a test message."
    else
      flash[:error] = "Oops! Looks like this employees information isn't up to date. Check to make sure they haven't changed their slackname!"
    end

    redirect_to redirect_path
  end

  private

  def message
    @message ||= if params[:scheduled_message_id]
                   ScheduledMessage.find(params[:scheduled_message_id])
                 else
                   Message.find(params[:message_id])
                 end
  end

  def slack_username
    params[:test_message][:slack_username]
  end

  def slack_user_id
    params[:test_message][:slack_user_id]
  end

  def redirect_path
    if params[:scheduled_message_id]
      scheduled_messages_path
    else
      messages_path
    end
  end
end
