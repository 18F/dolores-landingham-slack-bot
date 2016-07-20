class SendMessagesController < ApplicationController
  before_action :current_user_admin

  def create
    message = Message.find(params[:message_id])
    AllEmployeeMessageSender.new(message).run

    flash[:notice] = "Message sent to all users"
    redirect_to messages_path
  end
end
