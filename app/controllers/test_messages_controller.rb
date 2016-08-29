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
      flash[:notice] = I18n.t('controllers.test_messages_controller.notices.create')
    elsif employee.nil?
      flash[:error] = I18n.t('controllers.test_messages_controller.errors.create.employee_nil', slack_username: slack_username)
    else
      flash[:error] = I18n.t('controllers.test_messages_controller.errors.create.not_up_to_date')
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
