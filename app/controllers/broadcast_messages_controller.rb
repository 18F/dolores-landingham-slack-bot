class BroadcastMessagesController < ApplicationController
  before_action :current_user_admin, only: [:new, :create]

  def new
    @broadcast_message = BroadcastMessage.new
  end

  def create
    @broadcast_message = BroadcastMessage.new(broadcast_message_params)

    if @broadcast_message.save
      flash[:notice] = I18n.t(
        "controllers.broadcast_messages_controller.notices.create",
      )
      redirect_to broadcast_messages_path
    else
      flash.now[:error] = @broadcast_message.errors.full_messages.join(", ")
      render action: :new
    end
  end

  def index
    @broadcast_messages = BroadcastMessage.order(created_at: :desc)
  end

  private

  def broadcast_message_params
    params.require(:broadcast_message).permit(:title, :body)
  end
end
