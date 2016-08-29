class SendMessagesController < ApplicationController
  before_action :current_user_admin

  def create
    message = Message.find(params[:message_id])
    AllEmployeeMessageSender.new(message).run

    flash[:notice] = I18n.t('controllers.send_messages_controller.notices.create')
    redirect_to messages_path
  end
end
