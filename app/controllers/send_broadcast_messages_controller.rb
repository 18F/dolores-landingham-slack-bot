class SendBroadcastMessagesController < ApplicationController
  before_action :current_user_admin

  def create
    broadcast_message = BroadcastMessage.find(params[:broadcast_message_id])
    BroadcastMessageSender.new(broadcast_message).run

    flash[:notice] = I18n.t(
      "controllers.send_broadcast_messages_controller.notices.create",
    )
    redirect_to broadcast_messages_path
  end
end
