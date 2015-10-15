class ScheduledMessagesController < ApplicationController
  def new
    @scheduled_message = ScheduledMessage.new
  end

  def create
    @scheduled_message = ScheduledMessage.new(scheduled_message_params)

    if @scheduled_message.save
      flash[:notice] = "Scheduled message created successfully"
      redirect_to root_path
    else
      flash.now[:error] = "Could not create scheduled message"
      render action: :new
    end
  end

  def index
    @scheduled_messages = ScheduledMessage.order(:days_after_start)
  end

  def edit
    @scheduled_message = ScheduledMessage.find(params[:id])
  end

  def update
    @scheduled_message = ScheduledMessage.find(params[:id])

    if @scheduled_message.update(scheduled_message_params)
      flash[:notice] = "Scheduled message updated successfully"
      redirect_to scheduled_messages_path
    else
      flash.now[:error] = "Could not update scheduled message"
      render action: :edit
    end
  end

  private

  def scheduled_message_params
    params.require(:scheduled_message).permit(:body, :days_after_start, :tag_list, :title)
  end
end
