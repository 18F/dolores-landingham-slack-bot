class TestMessagesController < ApplicationController
  def new
    @message = message
    @url = if message.is_a? OnboardingMessage
             onboarding_message_test_messages_path(@message)
           elsif message.is_a? QuarterlyMessage
             quarterly_message_test_messages_path(@message)
           else
             broadcast_message_test_messages_path(@message)
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
    @message ||= if params[:onboarding_message_id]
                   OnboardingMessage.find(params[:onboarding_message_id])
                 elsif params[:quarterly_message_id]
                   QuarterlyMessage.find(params[:quarterly_message_id])
                 else
                   BroadcastMessage.find(params[:broadcast_message_id])
                 end
  end

  def slack_username
    params[:test_message][:slack_username]
  end

  def slack_user_id
    params[:test_message][:slack_user_id]
  end

  def redirect_path
    if params[:onboarding_message_id]
      onboarding_messages_path
    elsif params[:quarterly_message_id]
      quarterly_messages_path
    else
      broadcast_messages_path
    end
  end
end
