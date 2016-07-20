class MessagesController < ApplicationController
  before_action :current_user_admin, only: [:new, :create]

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      flash[:notice] = "Message created successfully"
      redirect_to messages_path
    else
      flash.now[:error] = @message.errors.full_messages.join(", ")
      render action: :new
    end
  end

  def index
    @messages = Message.order(created_at: :desc)
  end

  private

  def message_params
    params.require(:message).permit(:title, :body)
  end
end
